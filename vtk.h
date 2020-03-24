#ifndef VTK_H
#define VTK_H

using namespace std;

void write_vtk_to_file(
    string filename,
    vector<double> const& masses,
    vector<Vector3D> const& positions,
    vector<Vector3D> const& velocities,
    vector<Vector3D> const& forces) {

		ofstream file(filename);
		file << "# vtk DataFile Version 2.0\n";
		file << "Particle data" << endl;
		file << "ASCII" << endl;
		file << "DATASET UNSTRUCTURED_GRID\n";
		file << "POINTS " << positions.size() << " double\n";
		for(auto it = positions.begin(); it != positions.end(); ++it) {
				file << fixed << it->x << " ";
				file << fixed << it->y << " ";
				file << fixed << it->z << "\n";
		}
		file << "\n\n";
		file << "CELLS " << positions.size() << " " << 2 * positions.size() << endl;
		for(size_t i = 0; i < positions.size(); ++i) {
				file << "1 " << i << endl;
		}
		file << "\n\n";

		file << "CELL_TYPES " << positions.size() << endl;
		for(size_t i = 0; i < positions.size(); ++i) {
				file << "1" << endl;
		}
		file << "\n\n";

		file << "POINT_DATA " << masses.size() << "\n";

		file << "SCALARS mass double\n";
		file << "LOOKUP_TABLE default\n";
		for(size_t i = 0; i < masses.size(); ++i) {
				file << fixed << masses[i] << endl;
		}

		file << endl;

		file << "SCALARS velocity_x double\n";
		file << "LOOKUP_TABLE default\n";
		for(size_t i = 0; i < velocities.size(); ++i) {
				file << fixed << velocities[i].x << endl;
		}
		file << endl;

		file << "SCALARS velocity_y double\n";
		file << "LOOKUP_TABLE default\n";
		for(size_t i = 0; i < velocities.size(); ++i) {
				file << fixed << velocities[i].y << endl;
		}
		file << endl;

		file << "SCALARS velocity_z double\n";
		file << "LOOKUP_TABLE default\n";
		for(size_t i = 0; i < velocities.size(); ++i) {
				file << fixed << velocities[i].z << endl;
		}

		file << endl;
                file << "SCALARS force_x double\n";
		file << "LOOKUP_TABLE default\n";
		for(size_t i = 0; i < velocities.size(); ++i) {
				file << fixed << forces[i].x << endl;
		}
		file << endl;

		file << "SCALARS force_y double\n";
		file << "LOOKUP_TABLE default\n";
		for(size_t i = 0; i < velocities.size(); ++i) {
				file << fixed << forces[i].y << endl;
		}
		file << endl;

		file << "SCALARS force_z double\n";
		file << "LOOKUP_TABLE default\n";
		for(size_t i = 0; i < velocities.size(); ++i) {
				file << fixed << forces[i].z << endl;
		}

		file << endl;

		file.close();
}
#endif // VTK

