//======================================================================================================================
//
//  This file is part of waLBerla. waLBerla is free software: you can
//  redistribute it and/or modify it under the terms of the GNU General Public
//  License as published by the Free Software Foundation, either version 3 of
//  the License, or (at your option) any later version.
//
//  waLBerla is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
//  for more details.
//
//  You should have received a copy of the GNU General Public License along
//  with waLBerla (see COPYING.txt). If not, see <http://www.gnu.org/licenses/>.
//
//! \file ConfinedGas.cpp
//! \author Sebastian Eibl <sebastian.eibl@fau.de>
//
//======================================================================================================================


#include "blockforest/all.h"
#include "core/all.h"
#include "domain_decomposition/all.h"
#include "anydsl_md.h"

#include <pe/basic.h>
#include <pe/cr/PlainIntegrator.h>
#include <pe/statistics/BodyStatistics.h>
#include <pe/synchronization/SyncNextNeighbors.h>
#include <pe/synchronization/SyncShadowOwners.h>
#include <pe/utility/CreateWorld.h>
#include <pe/vtk/BodyVtkOutput.h>
#include <pe/vtk/SphereVtkOutput.h>

#include <core/Environment.h>
#include <core/grid_generator/HCPIterator.h>
#include <core/grid_generator/SCIterator.h>
#include <core/logging/Logging.h>
#include <core/timing/TimingTree.h>
#include <core/waLBerlaBuildInfo.h>
#include <postprocessing/sqlite/SQLite.h>
#include <vtk/VTKOutput.h>

using namespace walberla;
using namespace walberla::pe;
using namespace walberla::timing;

typedef boost::tuple<Sphere, Plane> BodyTuple ;


void log_vector(Vec3 vector) {
    WALBERLA_LOG_INFO_ON_ROOT("(" << vector[0] << ", " << vector[1] << ", " << vector[2] << ")");
}

void log_vector(double vector[3]) {
    WALBERLA_LOG_INFO_ON_ROOT("(" << vector[0] << ", " << vector[1] << ", " << vector[2] << ")");
}

int main( int argc, char ** argv )
{
   Environment env(argc, argv);
   WALBERLA_UNUSED(env);

   WALBERLA_LOG_INFO_ON_ROOT( "config file: " << argv[1] )

   WALBERLA_LOG_INFO_ON_ROOT( "waLBerla Revision: " << WALBERLA_GIT_SHA1 );

   WcTimingTree tt;

   math::seedRandomGenerator( static_cast<unsigned int>(1337 * mpi::MPIManager::instance()->worldRank()) );

   logging::Logging::instance()->setStreamLogLevel(logging::Logging::INFO);

   ///////////////////
   // Customization //
   ///////////////////

   // configuration file
   shared_ptr< Config > config = make_shared< Config >();
   config->readParameterFile( argv[1] );
   Config::BlockHandle mainConf = config->getBlock( "ConfinedGas" );

   const std::string sqlFile = mainConf.getParameter< std::string >( "sqlFile", "ConfinedGas.sqlite" );

   std::map< std::string, int64_t >     integerProperties;
   std::map< std::string, double >      realProperties;
   std::map< std::string, std::string > stringProperties;

   stringProperties["walberla_git"] = WALBERLA_GIT_SHA1;

   real_t spacing = mainConf.getParameter<real_t>("spacing", real_c(1.0) );
   WALBERLA_LOG_INFO_ON_ROOT("spacing: " << spacing);
   realProperties["spacing"] = double_c(spacing);

   real_t radius = mainConf.getParameter<real_t>("radius", real_c(0.4) );
   WALBERLA_LOG_INFO_ON_ROOT("radius: " << radius);
   realProperties["radius"] = double_c(radius);

   real_t vMax = mainConf.getParameter<real_t>("vMax", real_c(1.0) );
   WALBERLA_LOG_INFO_ON_ROOT("vMax: " << vMax);
   realProperties["vMax"] = vMax;

   int warmupSteps = mainConf.getParameter<int>("warmupSteps", 0 );
   WALBERLA_LOG_INFO_ON_ROOT("warmupSteps: " << warmupSteps);
   integerProperties["warmupSteps"] = warmupSteps;

   size_t simulationSteps = mainConf.getParameter<size_t>("simulationSteps", 200 );
   WALBERLA_LOG_INFO_ON_ROOT("simulationSteps: " << simulationSteps);
   integerProperties["simulationSteps"] = simulationSteps;

   real_t dt = mainConf.getParameter<real_t>("dt", real_c(0.01) );
   WALBERLA_LOG_INFO_ON_ROOT("dt: " << dt);
   realProperties["dt"] = dt;

   const int visSpacing = mainConf.getParameter<int>("visSpacing",  1 );
   WALBERLA_LOG_INFO_ON_ROOT("visSpacing: " << visSpacing);
   const std::string path = mainConf.getParameter<std::string>("path",  "vtk_out" );
   WALBERLA_LOG_INFO_ON_ROOT("path: " << path);


   WALBERLA_LOG_INFO_ON_ROOT("*** GLOBALBODYSTORAGE ***");
   shared_ptr<BodyStorage> globalBodyStorage = make_shared<BodyStorage>();

   WALBERLA_LOG_INFO_ON_ROOT("*** BLOCKFOREST ***");
   // create forest
   shared_ptr< BlockForest > forest = createBlockForestFromConfig( mainConf );
   if (!forest)
   {
      WALBERLA_LOG_INFO_ON_ROOT( "No BlockForest created ... exiting!");
      return EXIT_SUCCESS;
   }

   //write domain decomposition to file
   //vtk::writeDomainDecomposition(*forest);

   WALBERLA_LOG_INFO_ON_ROOT("simulationDomain: " << forest->getDomain());
   integerProperties["sim_x"] = int64_c(forest->getDomain().maxCorner()[0]);
   integerProperties["sim_y"] = int64_c(forest->getDomain().maxCorner()[1]);
   integerProperties["sim_z"] = int64_c(forest->getDomain().maxCorner()[2]);

   WALBERLA_LOG_INFO_ON_ROOT("blocks: " << Vector3<uint_t>(forest->getXSize(), forest->getYSize(), forest->getZSize()) );
   integerProperties["blocks_x"] = int64_c(forest->getXSize());
   integerProperties["blocks_y"] = int64_c(forest->getYSize());
   integerProperties["blocks_z"] = int64_c(forest->getZSize());

   MPI_Barrier(MPI_COMM_WORLD);
   WALBERLA_LOG_INFO_ON_ROOT("*** BODYTUPLE ***");
   MPI_Barrier(MPI_COMM_WORLD);
   // initialize body type ids
   SetBodyTypeIDs<BodyTuple>::execute();

   MPI_Barrier(MPI_COMM_WORLD);
   WALBERLA_LOG_INFO_ON_ROOT("*** STORAGEDATAHANDLING ***");
   MPI_Barrier(MPI_COMM_WORLD);
   // add block data
   auto storageID           = forest->addBlockData(createStorageDataHandling<BodyTuple>(), "Storage");

   WALBERLA_LOG_INFO_ON_ROOT("*** SYNCCALL ***");
   pe::syncNextNeighbors<BodyTuple>(*forest, storageID, &tt, real_c(0.0), false );

   WALBERLA_LOG_INFO_ON_ROOT("*** VTK ***");

   //auto vtkOutput   = make_shared<SphereVtkOutput>(storageID, *forest);
   //auto vtkWriter   = vtk::createVTKOutput_PointData(vtkOutput, "Bodies", 1, path, "simulation_step", false, false);

   WALBERLA_LOG_INFO_ON_ROOT("*** SETUP - START ***");
   const real_t   static_cof  ( 0.1 / 2 );   // Coefficient of static friction. Roughly 0.85 with high variation depending on surface roughness for low stresses. Note: pe doubles the input coefficient of friction for material-material contacts.
   const real_t   dynamic_cof ( static_cof ); // Coefficient of dynamic friction. Similar to static friction for low speed friction.
   MaterialID     material = createMaterial( "granular", real_t( 1.0 ), 0, static_cof, dynamic_cof, real_t( 0.5 ), 1, 1, 0, 0 );

   auto simulationDomain = forest->getDomain();
   auto generationDomain = simulationDomain; // simulationDomain.getExtended(-real_c(0.5) * spacing);
   createPlane(*globalBodyStorage, 0, Vec3(1,0,0), simulationDomain.minCorner(), material );
   createPlane(*globalBodyStorage, 0, Vec3(-1,0,0), simulationDomain.maxCorner(), material );
   createPlane(*globalBodyStorage, 0, Vec3(0,1,0), simulationDomain.minCorner(), material );
   createPlane(*globalBodyStorage, 0, Vec3(0,-1,0), simulationDomain.maxCorner(), material );
   createPlane(*globalBodyStorage, 0, Vec3(0,0,1), simulationDomain.minCorner(), material );
   createPlane(*globalBodyStorage, 0, Vec3(0,0,-1), simulationDomain.maxCorner(), material );

   //tt.start("Particle Creation");
   uint_t numParticles = uint_c(0);
   for (auto blkIt = forest->begin(); blkIt != forest->end(); ++blkIt)
   {
      IBlock & currentBlock = *blkIt;
      for (auto it = grid_generator::SCIterator(currentBlock.getAABB().getIntersection(generationDomain), Vector3<real_t>(0.5*spacing,0.5*spacing,0.5*spacing), spacing); it != grid_generator::SCIterator(); ++it)
      {
         SphereID sp = pe::createSphere( *globalBodyStorage, *forest, storageID, 0, *it, radius, material);
         Vec3 rndVel(math::realRandom<real_t>(-vMax, vMax), math::realRandom<real_t>(-vMax, vMax), math::realRandom<real_t>(-vMax, vMax));
         if (sp != NULL) sp->setLinearVel(rndVel);
         if (sp != NULL) ++numParticles;
      }
   }
   //tt.stop("Particle Creation");
      
   WALBERLA_LOG_INFO_ON_ROOT("#particles per process: " << numParticles);
   mpi::reduceInplace(numParticles, mpi::SUM);
   WALBERLA_LOG_INFO_ON_ROOT("#particles in total: " << numParticles);

   WALBERLA_LOG_INFO_ON_ROOT("*** SETUP - END ***");

    

   // synchronize particles
   pe::syncNextNeighbors<BodyTuple>(*forest, storageID, &tt, real_c(0.0), false );
   pe::syncNextNeighbors<BodyTuple>(*forest, storageID, &tt, real_c(0.0), false );

   WALBERLA_LOG_INFO_ON_ROOT("*** SIMULATION - START ***");
   WcTimingPool tp;
   tt.start("Simulation Loop");
   for (size_t i=0; i < simulationSteps; ++i)
   {
       if( i % 10 == 0 )
       {
           WALBERLA_LOG_DEVEL_ON_ROOT( "Timestep " << i << " / " << simulationSteps );
       }
       tt.start("Reinitialization");
       anydsl_md_reinitialize_blocks(forest, storageID);
       tt.stop("Reinitialization");
       /*
       tt.start("Visualization");
       if( i % visSpacing == 0 )
       {
           vtkWriter->write( true );
       }
       tt.stop("Visualization");
       */
       tt.start("Solver");
       anydsl_md_time_integration(dt, i);
       tt.stop("Solver");

       tt.start("Sync");
       pe::syncNextNeighbors<BodyTuple>(*forest, storageID, &tt, real_c(0.0), false );
       tt.stop("Sync");
   }
   anydsl_md_delete_blocks();
   tt.stop("Simulation Loop");
   MPI_Barrier(MPI_COMM_WORLD);
   WALBERLA_LOG_INFO_ON_ROOT("*** SIMULATION - END ***");

   auto temp = tt.getReduced( );
   WALBERLA_ROOT_SECTION()
   {
      std::cout << temp;
   }
   auto tpReduced = tp.getReduced();
   WALBERLA_ROOT_SECTION()
   {
      WALBERLA_LOG_DEVEL(*tpReduced);
      // Log to SQL Database
      /*
      auto runId = postprocessing::storeRunInSqliteDB( sqlFile, integerProperties, stringProperties, realProperties );
      postprocessing::storeTimingPoolInSqliteDB( sqlFile, runId, *tpReduced, "Timeloop" );
      postprocessing::storeTimingTreeInSqliteDB( sqlFile, runId, tt, "TimingTree" );
      */
   }

   return EXIT_SUCCESS;
}

