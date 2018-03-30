# Tracking Evaluation Toolkit

The toolkit is used to evaluate visual trackers - it implements VOT measures accuracy and robustness on a baseline (reset-based) experiment. The toolkit is tested on Matlab and Octave and it is compatible with [VOT sequences](http://www.votchallenge.net/challenges.html).

<b>Note:</b> The toolkit is developed for educational purposes only (course Advanced Computer Vision Methods at Faculty of Computer and information Science, University of Ljubljana) and it should not be used in research community.

## How to create workspace:
1.)	Checkout the repository in an empty folder - called `toolkit` </br>
2.)	Create new folder (not within `toolkit`) - called `workspace` </br>
3.)	Add the `toolkit` path to Matlab paths </br>
4.)	Run command (within `workspace` folder): `create_tracker_workspace` </br>
5.)	A script called `workspace_config` will appear in the `workspace`. Set the following variables according to your settings in this script: </br>
```bash
c.tracker_name = ‘<tracker-name>’;
c.additional_paths = {‘add-paths’};  % Path to the source code directory
c.dataset_path = ‘path-to-dataset-directory’;
```

## Design of a tracker:
Implement the tracker (with name `<tracker-name>`) in two functions: </br>
```bash
tracker = <tracker-name>_initialize(img, bbox)
[tracker, bbox] = <tracker-name>_update(tracker, img)
```
You can see an example for the NCC tracker (located in [`examples/ncc`](examples/ncc) folder).

## Tracker evaluation:
In the `workspace` folder run command: `run_experiment`. The toolkit will run the tracker on all sequences and save results in the results folder. After the experiment is over you can call: </br>
* `performance_summary` Tracking performance of the tracker specified in `workspace_config` will be printed out and a latex table will be generated in output folder. </br>
* `compare_trackers({‘list-comma-separated-tracker-names’})` Generates similar latex table as `performance_summary` script, but with multiple columns corresponding to multiple trackers. Additionally, an A-R plot will be generated and stored in output folder.
