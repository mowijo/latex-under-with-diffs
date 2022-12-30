set terminal pdf

f(x,y) = exp(-((x-4)**2+(y-4)**2)**2/1000)    \
		+ exp(-((x +4)**2+(y+4)**2)**2/1000)  \
		+ 0.1 * exp(-((x +4)**2+(y+4)**2)**2) \
		+ 0.1 * exp(-((x -4)**2+(y-4)**2)**2)

unset colorbox
set pm3d
set hidden3d
set isosamples 100
set zrange [0:1.2]
set format x ""
set format y ""
set format z ""
unset xtics
unset ytics
unset ztics

splot f(x,y) with pm3d notitle