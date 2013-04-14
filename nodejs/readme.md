# Next

Next step is to have the browser return the unit test results via ajax to the
node server. The node server then stores the result for that update and browser
combination. 

--------------------------------------------------------------------------------

## Control interface

A control interface long polls the server for new results via ajax and renders 
them to a control screen. The control screen has different views.

--------------------------------------------------------------------------------

## Latest summary

This view shows the results for the latest update for each browser and version.

--------------------------------------------------------------------------------

## Browser update table

This view shows the browser result for each update. It combines the result for
the different versions to give the worst case view showing the total number of
tests that have failed across any version. Clicking the result shows the 
failures marked with the affected version.

--------------------------------------------------------------------------------

## Browser version update summary table 

This is a view that shows the test / update number vertically and the different 
browsers + versions horizontally. Each cell is split into three showing the 
number of tests, the number of fails and the number of passes, clicking one of 
these squares opens the individual test view for that test.

             +-----------------------------+--------------+
	         | Internet Explorer           | Firefox      |
	+--------+--------------+--------------+--------------+
	| Update | 6            | 7            | 15           |
	+--------+----+----+----+----+----+----+----+----+----+
	| 13221  | 12 |  0 | 12 | 12 |  1 | 11 | 12 |  0 | 12 |
	+--------+----+----+----+----+----+----+----+----+----+
	| 13222  | 12 |  0 | 12 | 12 |  0 | 12 | 12 |  0 | 12 |
	+--------+----+----+----+----+----+----+----+----+----+
	| 13223  | 15 |  3 | 12 | 15 |  3 | 12 | 15 |  3 | 12 |
	+--------+----+----+----+----+----+----+----+----+----+
	| 13224  | 15 |  3 | 12 | 14 |  2 | 13 | 14 |  2 | 13 |
	+--------+----+----+----+----+----+----+----+----+----+
	... etc.

--------------------------------------------------------------------------------
