# set terminal postscript eps enhanced
# set output 'exhaustive_performance.eps'

set ylabel "Computation Time (ms)"
set xlabel "No. of ingested records"

set key box top left inside Left samplen 1
#set logscale y 2
#set xrange [0:9]
#set xtics ('10' 0, '50' 1, '100' 2, '200' 3, '500' 4, '1000' 5, '2000' 6, '5000' 7, '10000' 8, '20000' 9)

plot 'performance_cumulative.dat' u 2:xtic(1) t 'W1' w lp pt 9,\
'performance_cumulative.dat' u 3:xtic(1) t 'W2' w lp pt 9,\
'performance_cumulative.dat' u 4:xtic(1) t 'W3' w lp pt 9,\
'performance_cumulative.dat' u 5:xtic(1) t 'W4' w lp pt 9,\
'performance_cumulative.dat' u 6:xtic(1) t 'W5' w lp pt 9,\

