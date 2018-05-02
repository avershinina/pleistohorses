# Repeatmasker filter
```
repeatmasker_filter.R
```
Input: data downloaded from repeatmasker.org.   
Output: bed-like file with coordinates.  
Options: 
* filter out by -div (divergence from a common ancestor);
* remove low_complexity and simple_repeat categories;
* take chromosome of interest

# PhastCons wiggles
## convert to cooordinates
```
phastCons2coords.py
```
Goal: Convert phastCons wiggle file (with fixed step) to a file with coordinates.
Input: PhastCons wiggle
```
fixedStep chrom=chr1 start=6762 step=1
0.001
0.002
0.004
```
Output: tabulated file with coordinates and scores.
```
	group	score	start
0	6762	0.001	6762
1	6762	0.002	6763
```
Usage: python2 script.py infile.txt outfile.tab
