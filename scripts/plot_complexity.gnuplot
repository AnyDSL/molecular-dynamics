set terminal svg enhanced size 500,500
set output 'complexity.svg'
set encoding iso_8859_1
set xlabel 'Number of Particles'
set ylabel 'Runtime (s)'
set xrange [100:]
set xtics 100,100,2000
set style line 1 lc rgb '#0060ad' lt 1 lw 1 pt 7 ps 0.5   # --- blue
set style line 2 lc rgb '#dd181f' lt 1 lw 1 pt 7 ps 0.5 
plot filename1 using 1:2:3 w yerrorbars ls 1 notitle, \
filename1 using 1:2 w lines ls 1 title "Basic Algorithm", \
filename2 using 1:2 w lines ls 2 title "Cell List Algorithm"
