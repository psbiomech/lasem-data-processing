# LASEM Body Builder C3D Processing Package

Extract and process C3D files post-processed in Body Builder.

This project is licensed under the GNU General Public License v3.0 (see License below).


## Inputs

C3D files post-processed through Body Builder. Files should be arranged in a single folder or a nested/tree folder structure.

Files should have a naming convention of the form:
```text
(SUBJECT PREFIX)(SUBJECT CODE)(SEPARATOR)(TRIAL PREFIX)(TRIAL CODE).c3d
```

Prefixes, codes and separator are treated as strings, so may be text or numeric. Codes may also contain leading zeros.

For example:
```text
FAILT01_SLDJ03.c3d
```
Where:
* SUBJECT PREFIX: FAILT
* SUBJECT CODE: 01
* SEPARATOR: \_ (underscore)
* TRIAL PREFIX: SLDJ
* TRIAL CODE: 03

## Outputs

Body Builder data from C3D file:
1. Angles
2. Moments
3. Powers
4. GRFs

Additional analyses:
1. Joint rotational work (net, positive, negative, 1st half, 2nd half, segments)
2. Joint rotational impulse (net, positive, negative, 1st half, 2nd half, segments)
3. Ground impulse (net, positive, negative, 1st half, 2nd half, segments)
4. Values at events

Processing: 
1. Raw Body Builder data from individual C3D files
2. Subject means and stdev
3. Total cohort means and stdev

Task types analysed:
1. Walking (stance)
2. Running (stance)
3. Single-leg drop and jump

## Getting started

Download **lasem-data-processing** package and unzip in a convenient location.

## Preparing to run

Modify the field values in function *getUserScriptSettings()* as required for the data to be extracted and processed. 

## Running the package

To run the package, execute the script *ProcessBB.m*.

## Adding new tasks

To analyse a new type of task, write a new function for that task in the package subfolder **./tasks** and modify the *select-case* in the function *getC3Dwindow()* to include the new task. Inputs and outputs for the new function should match the those of the default package functions, e.g. *task_walk_stance()*

## Adding new analyses

To add a new analysis, write a new function for that analysis in the package subfolder **./analyses** and modify the function *runAnalyses()* to include the new analyses. Inputs and outputs for the new function should match the those of the default package functions, e.g. *analysis_work_rotational()*

To calculate subject and cohort means and standard deviations for the new analysis, write a new function for calculating means and standard deviations in the package subfolder **./analyses** and modify the function *calcAnalysesMeans()* to include the new mean and standard deviation analysis. Inputs and outputs for the new function should match the those of the default package functions, e.g. *analysis_mean_work_rotational()* 

## Authors

**Prasanna Sritharan**  
La Trobe Sports and Exercise Medicine Research Centre  
La Trobe University, Victoria, Australia  
psritharan@ltu.edu.au

## License

This project is licensed under the GNU General Public License v3.0.

For full license terms, please refer to the *LICENSE* file or visit *http://www.gnu.org/licenses/*.

	Copyright (C) 2017  Prasanna Sritharan

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
