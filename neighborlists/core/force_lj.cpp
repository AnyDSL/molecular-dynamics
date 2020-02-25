#define PAD         3
#define MMD_float   double

extern "C" {

void compute_fullneigh(
    int nlocal,
    MMD_float cutforcesq,
    MMD_float* const x,
    MMD_float* const f,
    const int* const neighbors,
    const int* const numneigh,
    const int maxneighs) {

    // clear force on own and ghost atoms

    for(int i = 0; i < nlocal; i++) {
        f[i * PAD + 0] = 0.0;
        f[i * PAD + 1] = 0.0;
        f[i * PAD + 2] = 0.0;
    }

    // loop over all neighbors of my atoms
    // store force on atom i

    for(int i = 0; i < nlocal; i++) {
        const int* const neighs = &neighbors[i * maxneighs];
        const int numneighs = numneigh[i];
        const MMD_float xtmp = x[i * PAD + 0];
        const MMD_float ytmp = x[i * PAD + 1];
        const MMD_float ztmp = x[i * PAD + 2];
        MMD_float fix = 0;
        MMD_float fiy = 0;
        MMD_float fiz = 0;

        for(int k = 0; k < numneighs; k++) {
            const int j = neighs[k];
            const MMD_float delx = xtmp - x[j * PAD + 0];
            const MMD_float dely = ytmp - x[j * PAD + 1];
            const MMD_float delz = ztmp - x[j * PAD + 2];
            const MMD_float rsq = delx * delx + dely * dely + delz * delz;

            if(rsq < cutforcesq) {
                const MMD_float sr2 = 1.0 / rsq;
                const MMD_float sr6 = sr2 * sr2 * sr2;
                const MMD_float force = 48.0 * sr6 * (sr6 - 0.5) * sr2;
                fix += delx * force;
                fiy += dely * force;
                fiz += delz * force;
            }
        
        }

        f[i * PAD + 0] += fix;
        f[i * PAD + 1] += fiy;
        f[i * PAD + 2] += fiz;
    }
}

}
