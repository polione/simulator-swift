

set ylabel "Computation Time (ms)"
set xlabel "No. of ingested records"
#base_path = '../../Experiments/Simulator/'
base_path = ''
#set yrange[0:4096]
set key box top left inside Left samplen 1
set xtics autofreq 1
#set logscale y 2

set size 1,1
set origin 0,0
set multiplot layout 2,2 rowsfirst scale 1.1,0.9


do for [i=0:3] {
  set xlabel sprintf("Number Of Services")
  set label sprintf("{/:Bold %d Nodes}", i+3) at graph 0.5, graph -0.3 center
  plot for [IDX=0:(i+3)] base_path.'window_time_performance_pippo.mytable_gamma_bad_n'.(i+3).'.dat' i IDX u 1:($2/100) w lp pt IDX+1 title sprintf("Window Size %d", (IDX+3))
  unset label

}

set logscale y 2

unset multiplot

set terminal postscript eps enhanced
set output 'window_performance.eps'
replot

unset output
