

set ylabel "Computation Time (ms)"
set xlabel "No. of ingested records"
base_path = '../../Experiments/Simulator/'

#set yrange[0:4096]
set key box top left inside Left samplen 1
#set logscale y 2

set size 1,1
set origin 0,0
set multiplot layout 2,3 rowsfirst scale 1.1,0.9

set xlabel "Window Size 1 (GREEDY)"
plot  base_path.'event_newwindown_n3_w1.dat' u 2:4 t '3 Nodes' w lp pt 6, \
      base_path.'event_newwindown_n3_w1.dat' u 2:4 t '3 Nodes' w lp pt 6, \
      base_path.'event_newwindown_n4_w1.dat' u 2:4 t '4 Nodes ' w lp pt 7, \
      base_path.'event_newwindown_n5_w1.dat' u 2:4 t '5 Nodes' w lp pt 8, \
      base_path.'event_newwindown_n6_w1.dat' u 2:4 t '6 Nodes ' w lp pt 9, \
      base_path.'event_newwindown_n7_w1.dat' u 2:4 t '7 Nodes ' w lp pt 10

set xlabel "Window Size 2"
plot  base_path.'event_newwindown_n3_w2.dat' u 2:4 t '3 Nodes' w lp pt 6, \
      base_path.'event_newwindown_n4_w2.dat' u 2:4 t '4 Nodes ' w lp pt 7, \
      base_path.'event_newwindown_n5_w2.dat' u 2:4 t '5 Nodes' w lp pt 8, \
      base_path.'event_newwindown_n6_w2.dat' u 2:4 t '6 Nodes ' w lp pt 9, \
      base_path.'event_newwindown_n7_w2.dat' u 2:4 t '7 Nodes ' w lp pt 10

set xlabel "Window Size 3"
plot   base_path.'event_newwindown_n3_w3.dat' u 2:4 t '3 Nodes' w lp pt 6, \
       base_path.'event_newwindown_n4_w3.dat' u 2:4 t '4 Nodes' w lp pt 7, \
       base_path.'event_newwindown_n5_w3.dat' u 2:4 t '5 Nodes' w lp pt 8, \
       base_path.'event_newwindown_n6_w3.dat' u 2:4 t '6  Nodes' w lp pt 9, \
       base_path.'event_newwindown_n7_w3.dat' u 2:4 t '7 Nodes ' w lp pt 10

set xlabel "Window Size 4"
plot   base_path.'event_newwindown_n4_w4.dat' u 2:4 t '4 Nodes' w lp pt 7, \
       base_path.'event_newwindown_n5_w4.dat' u 2:4 t '5 Nodes' w lp pt 8, \
       base_path.'event_newwindown_n6_w4.dat' u 2:4 t '6 Nodes ' w lp pt 9, \
       base_path.'event_newwindown_n7_w4.dat' u 2:4 t '7 Nodes' w lp pt 10

set xlabel "Window Size 5"
plot   base_path.'event_newwindown_n5_w5.dat' u 2:4 t '5 Nodes' w lp pt 8, \
       base_path.'event_newwindown_n6_w5.dat' u 2:4 t '6 Nodes' w lp pt 9, \
       base_path.'event_newwindown_n7_w5.dat' u 2:4 t '7 Nodes ' w lp pt 10
unset multiplot
set terminal postscript eps enhanced
set output 'window_performance.eps'

replot

unset output

