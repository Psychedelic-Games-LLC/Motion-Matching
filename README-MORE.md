# installation and prebuild
for raylib and raygui check this link
https://github.com/raysan5/raylib/wiki/Working-for-Web-(HTML5)

# build

### emsdk
after emsdk is installed, I choose to not pollute PATH and just  
add emsdk to PATH each time I start working with it in terminal with this command
(change path according to your own location of emsdk)
```bash
source ~/_WORK/Motion-Matching/emsdk/emsdk_env.sh
```

### compile full demo (controller.html)
```bash
make PLATFORM=PLATFORM_WEB TYPE=TST
```

### compile stripped demo (mmatching.html)
this is my attempt to isolate most core things that motion matching needs to later create functions that will be called from js with minimum of data transfer
```bash
 make PLATFORM=PLATFORM_WEB TYPE=TST mmatching
```


# core parts

what i found so far, to search next pose they use legs and hip positions and their projected future positions and rotations
```c++
// Make query vector for search.
// In theory this only needs to be done when a search is
// actually required however for visualization purposes it
// can be nice to do it every frame
array1d<float> query(db.nfeatures());

// Compute the features of the query vector

slice1d<float> query_features = lmm_enabled ? slice1d<float>(features_curr) : db.features(frame_index);

int offset = 0;
query_copy_denormalized_feature(query, offset, 3, query_features, db.features_offset, db.features_scale); // Left Foot Position
query_copy_denormalized_feature(query, offset, 3, query_features, db.features_offset, db.features_scale); // Right Foot Position
query_copy_denormalized_feature(query, offset, 3, query_features, db.features_offset, db.features_scale); // Left Foot Velocity
query_copy_denormalized_feature(query, offset, 3, query_features, db.features_offset, db.features_scale); // Right Foot Velocity
query_copy_denormalized_feature(query, offset, 3, query_features, db.features_offset, db.features_scale); // Hip Velocity
query_compute_trajectory_position_feature(query, offset, bone_positions(0), bone_rotations(0), trajectory_positions);
query_compute_trajectory_direction_feature(query, offset, bone_rotations(0), trajectory_rotations);
```

this is what looks like search itself
```c++
int best_index = end_of_anim ? -1 : frame_index;
float best_cost = FLT_MAX;

database_search(
        best_index,
        best_cost,
        db,
        query);

// Transition if better frame found

if (best_index != frame_index)
{
    trns_bone_positions = db.bone_positions(best_index);
    trns_bone_velocities = db.bone_velocities(best_index);
    trns_bone_rotations = db.bone_rotations(best_index);
    trns_bone_angular_velocities = db.bone_angular_velocities(best_index);

    inertialize_pose_transition(
            bone_offset_positions,
            bone_offset_velocities,
            bone_offset_rotations,
            bone_offset_angular_velocities,
            transition_src_position,
            transition_src_rotation,
            transition_dst_position,
            transition_dst_rotation,
            bone_positions(0),
            bone_velocities(0),
            bone_rotations(0),
            bone_angular_velocities(0),
            curr_bone_positions,
            curr_bone_velocities,
            curr_bone_rotations,
            curr_bone_angular_velocities,
            trns_bone_positions,
            trns_bone_velocities,
            trns_bone_rotations,
            trns_bone_angular_velocities);

    frame_index = best_index;
}
```

for normal walk/run it's all nice, but what i'm not sure is how it will work and how it should be modified when it will come to dribbling(walk/run with ball)
right now they don't care much about bones other then feet/hips, but we will probably need add hands also?