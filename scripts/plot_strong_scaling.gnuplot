set terminal svg enhanced size 500,500
set output 'strong_scaling.svg'
set encoding iso_8859_1
set xlabel 'Processors'
set ylabel 'Runtime (s)'
set xrange [1:4]
set yrange [0:3]
set xtics 1,1,8
#set nokey
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 7 ps 1.5   # --- blue
set style line 2 lc rgb '#dd181f' lt 1 lw 2 pt 5 ps 1.5   # --- red
plot "strong_scaling.dat" u 1:2 title 'C' with linespoints ls 1 , \
"strong_scaling.dat" u 1:3 title 'Impala' with linespoints ls 2
