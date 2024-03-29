
set ylabel "Computation Time (s)"
set xlabel "No. of services"

set key box top left inside Left samplen 1
set grid
#set xrange [0:9]
#set xtics ('10' 0, '50' 1, '100' 2, '200' 3, '500' 4, '1000' 5, '2000' 6, '5000' 7, '10000' 8, '20000' 9)
set multiplot layout 2,1 rowsfirst
 set logscale y 2;
plot\
  'exhaustive_performance.dat' u 1:2  t '2 Nodes' w lp pt 9 ,\
  'exhaustive_performance.dat' u 1:3  t '3 Nodes' w lp pt 7, \
  'exhaustive_performance.dat' u 1:4  t '4 Nodes' w lp pt 6, \
  'exhaustive_performance.dat' u 1:5  t '5 Nodes' w lp pt 5,\
  'exhaustive_performance.dat' u 1:6  t '6 Nodes' w lp pt 4
unset logscale y
plot\
  'exhaustive_performance.dat' u 1:2  t '2 Nodes' w lp pt 9 ,\
  'exhaustive_performance.dat' u 1:3  t '3 Nodes' w lp pt 7, \
  'exhaustive_performance.dat' u 1:4  t '4 Nodes' w lp pt 6, \
  'exhaustive_performance.dat' u 1:5  t '5 Nodes' w lp pt 5,\
  'exhaustive_performance.dat' u 1:6  t '6 Nodes' w lp pt 4
unset multiplot

# while(1) {
#   replot;
#   pause 5
# }

#   }
set terminal postscript eps enhanced
set output 'exhaustive_performance.eps'

replot

unset output