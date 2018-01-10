set terminal svg enhanced size 500,500
set output 'processor_scaling.svg'
set encoding iso_8859_1
set xlabel 'Processors'
set ylabel 'Runtime (s)'
set yrange [0:1.5]
set xtics 1,1,8
set style line 1 lc rgb '#0060ad' lt 1 lw 1 pt 7 ps 0.5   # --- blue
set style line 2 lc rgb '#dd181f' lt 1 lw 1 pt 7 ps 0.5 
plot filename1 using 1:2:3 w yerrorbars ls 1 notitle, \
filename1 using 1:2 w linespoints ls 1 title "C", \
filename2 using 1:2:3 w yerrorbars ls 2 notitle, \
filename2 using 1:2 w linespoints ls 2 title "Impala"
