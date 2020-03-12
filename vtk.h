#ifndef VTK_H
#define VTK_H
void write_vtk_to_file(std::string filename, std::vector<double> const& masses, std::vector<Vector3D>const & positions, std::vector<Vector3D>const & velocities, std::vector<Vector3D>const &forces) {
		std::ofstream file(filename);
		file << "# vtk DataFile Version 2.0\n";
		file << "Particle data" << std::endl;
		file << "ASCII" << std::endl;
		file << "DATASET UNSTRUCTURED_GRID\n";
		file << "POINTS " << positions.size() << " double\n";
		for(auto it = positions.begin(); it != positions.end(); ++it) {
				file << std::fixed << it->x << " ";
				file << std::fixed << it->y << " ";
				file << std::fixed << it->z << "\n";
		}
		file << "\n\n";
		file << "CELLS " << positions.size() << " " << 2 * positions.size() << std::endl;
		for(std::size_t i = 0; i < positions.size(); ++i) {
				file << "1 " << i << std::endl;
		}
		file << "\n\n";

		file << "CELL_TYPES " << positions.size() << std::endl;
		for(std::size_t i = 0; i < positions.size(); ++i) {
				file << "1" << std::endl;
		}
		file << "\n\n";

		file << "POINT_DATA " << masses.size() << "\n";

		file << "SCALARS mass double\n";
		file << "LOOKUP_TABLE default\n";
		for(std::size_t i = 0; i < masses.size(); ++i) {
				file << std::fixed << masses[i] << std::endl;
		}

		file << std::endl;

		file << "SCALARS velocity_x double\n";
		file << "LOOKUP_TABLE default\n";
		for(std::size_t i = 0; i < velocities.size(); ++i) {
				file << std::fixed << velocities[i].x << std::endl;
		}
		file << std::endl;

		file << "SCALARS velocity_y double\n";
		file << "LOOKUP_TABLE default\n";
		for(std::size_t i = 0; i < velocities.size(); ++i) {
				file << std::fixed << velocities[i].y << std::endl;
		}
		file << std::endl;

		file << "SCALARS velocity_z double\n";
		file << "LOOKUP_TABLE default\n";
		for(std::size_t i = 0; i < velocities.size(); ++i) {
				file << std::fixed << velocities[i].z << std::endl;
		}

		file << std::endl;
                file << "SCALARS force_x double\n";
		file << "LOOKUP_TABLE default\n";
		for(std::size_t i = 0; i < velocities.size(); ++i) {
				file << std::fixed << forces[i].x << std::endl;
		}
		file << std::endl;

		file << "SCALARS force_y double\n";
		file << "LOOKUP_TABLE default\n";
		for(std::size_t i = 0; i < velocities.size(); ++i) {
				file << std::fixed << forces[i].y << std::endl;
		}
		file << std::endl;

		file << "SCALARS force_z double\n";
		file << "LOOKUP_TABLE default\n";
		for(std::size_t i = 0; i < velocities.size(); ++i) {
				file << std::fixed << forces[i].z << std::endl;
		}

		file << std::endl;

		file.close();
}
#endif // VTK

