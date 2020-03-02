; ModuleID = 'RAYTRACE.opt.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.view = type { [4 x double], [4 x double], [4 x [4 x double]], [4 x [4 x double]], [4 x [4 x double]], [3 x double], i64, double, [3 x double], i64, i64 }
%struct.display = type { i64, i64, i64, i64, double, i64, i64, i64, double, double, double, double, double, double, double, double, %struct.pixel* }
%struct.pixel = type { float, float, float }
%struct.light = type { [4 x double], [3 x double], i64, %struct.light* }
%struct.gmem = type { i64, i64, i64, %struct.object*, %struct.grid*, %struct.node*, [128 x [256 x i64]], [128 x [256 x %struct.wpjob*]], %struct.barrier_t, %union.pthread_mutex_t, %union.pthread_mutex_t, %union.pthread_mutex_t, [128 x %union.pthread_mutex_t], i64, [128 x i64] }
%struct.object = type { i64, [30 x i8], %struct.bbox, %struct.element*, i64, %struct.pprocs*, %struct.surf*, %struct.object* }
%struct.bbox = type { [3 x double], [3 x double] }
%struct.element = type { i64, %struct.bbox, %struct.object*, i8* }
%struct.pprocs = type { i8* (...)*, void (...)*, void (...)*, void (...)*, void (...)*, i64 (...)*, i64 (...)*, void (...)*, void (...)*, void (...)* }
%struct.surf = type { [3 x double], [3 x double], double, double, double, double, double }
%struct.grid = type { i64, %struct.voxel**, i64*, %struct.element**, i64, [3 x i64], i64, [3 x double], [3 x double], i64, %struct.btnode*, %struct.grid* }
%struct.voxel = type { i64, i8*, i8, i64, %struct.voxel* }
%struct.btnode = type { %struct.element**, [3 x double], i64, [3 x i64], [3 x i64], i64, i64, [2 x %struct.btnode*] }
%struct.node = type { %struct.node*, i64, i64, i64 }
%struct.wpjob = type { i64, i64, i64, i64, %struct.wpjob* }
%struct.barrier_t = type { i32, i64 }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct.CTE = type { i8*, i8 }
%struct.anon = type { i8, i8, i8, i8 }
%struct.r_struct = type { [4096 x i64], %struct.ray*, i64, i64, [4096 x i64] }
%struct.ray = type { i64, i64, i64, [3 x double], [3 x double], i64, float, [3 x i64], %struct.rayinfo*, i64, [5 x %struct.rayinfo] }
%struct.rayinfo = type { %struct.grid*, [3 x double], i64, double, i64, double, [3 x double], [3 x i64], i64, [3 x i64], %struct.rayinfo* }
%struct.irecord = type { double, %struct.element*, double, double, double }
%union.pthread_attr_t = type { i64, [48 x i8] }
%union.pthread_mutexattr_t = type { i32 }
%struct.poly = type { i64, [3 x double], double, [3 x double]*, i64*, i64 }
%struct.sphere = type { [4 x double], double, double }
%struct.rayjob = type { i64, i64, i64, i64, i64, i64 }
%struct.tri = type { [3 x double], double, [3 x double]*, [3 x double]*, [3 x i64], i64, i64, i64 }

@DataType = internal global i64 0, align 8
@TraversalType = internal global i64 0, align 8
@bundlex = internal global i64 0, align 8
@bundley = internal global i64 0, align 8
@blockx = internal global i64 0, align 8
@blocky = internal global i64 0, align 8
@GeoFile = internal global i64 0, align 8
@PicFile = internal global i64 0, align 8
@ModelNorm = internal global i64 0, align 8
@ModelTransform = internal global i64 0, align 8
@AntiAlias = internal global i64 0, align 8
@GeoFileName = internal global [80 x i8] zeroinitializer, align 16
@PicFileName = internal global [80 x i8] zeroinitializer, align 16
@View = internal global %struct.view zeroinitializer, align 8
@Display = internal global %struct.display zeroinitializer, align 8
@lights = internal global %struct.light* null, align 8
@nlights = internal global i64 0, align 8
@gm = internal global %struct.gmem* null, align 8
@world_level_grid = internal global %struct.grid* null, align 8
@hu_max_prims_cell = internal global i64 0, align 8
@hu_gridsize = internal global i64 0, align 8
@hu_numbuckets = internal global i64 0, align 8
@hu_max_subdiv_level = internal global i64 0, align 8
@hu_lazy = internal global i64 0, align 8
@prim_obj_cnt = internal global i64 0, align 8
@prim_elem_cnt = internal global i64 0, align 8
@subdiv_cnt = internal global i64 0, align 8
@bintree_cnt = internal global i64 0, align 8
@grids = internal global i64 0, align 8
@total_cells = internal global i64 0, align 8
@empty_voxels = internal global i64 0, align 8
@nonempty_voxels = internal global i64 0, align 8
@nonempty_leafs = internal global i64 0, align 8
@prims_in_leafs = internal global i64 0, align 8
@empty_masks = internal global [64 x i64] zeroinitializer, align 16
@nonempty_masks = internal global [64 x i64] zeroinitializer, align 16
@gridlist = internal global %struct.grid* null, align 8
@stderr = external global %struct._IO_FILE*, align 8
@.str = private unnamed_addr constant [21 x i8] c"    Print Gridlist \0A\00", align 1
@.str.1 = private unnamed_addr constant [19 x i8] c"    End Gridlist \0A\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.3 = private unnamed_addr constant [68 x i8] c"****** Hierarchical uniform grid data structure statistics ******\0A\0A\00", align 1
@.str.4 = private unnamed_addr constant [47 x i8] c"    Data structure evaluated as a preprocess.\0A\00", align 1
@.str.5 = private unnamed_addr constant [48 x i8] c"    gridsize                             %3ld \0A\00", align 1
@.str.6 = private unnamed_addr constant [48 x i8] c"    hashtable buckets                    %3ld \0A\00", align 1
@.str.7 = private unnamed_addr constant [48 x i8] c"    maximum subdivision level            %3ld \0A\00", align 1
@.str.8 = private unnamed_addr constant [48 x i8] c"    maximum primitives / cell            %3ld \0A\00", align 1
@.str.9 = private unnamed_addr constant [48 x i8] c"    grids                                %3ld \0A\00", align 1
@.str.10 = private unnamed_addr constant [54 x i8] c"    empty voxels                    %8ld    %3ld %% \0A\00", align 1
@.str.11 = private unnamed_addr constant [54 x i8] c"    nonempty voxels                 %8ld    %3ld %% \0A\00", align 1
@.str.12 = private unnamed_addr constant [54 x i8] c"    empty leafs                     %8ld    %3ld %% \0A\00", align 1
@.str.13 = private unnamed_addr constant [54 x i8] c"    nonempty leafs                  %8ld    %3ld %% \0A\00", align 1
@.str.14 = private unnamed_addr constant [47 x i8] c"    primitives / leaf                 %6.1lf \0A\00", align 1
@.str.15 = private unnamed_addr constant [66 x i8] c"bintree_lookup: gridsizes (%ld, %ld, %ld), axis %ld & nprims %ld\0A\00", align 1
@cmdtab = internal global [42 x %struct.CTE] [%struct.CTE { i8* getelementptr inbounds ([4 x i8]* @.str.16, i32 0, i32 0), i8 97 }, %struct.CTE { i8* getelementptr inbounds ([7 x i8]* @.str.1.17, i32 0, i32 0), i8 98 }, %struct.CTE { i8* getelementptr inbounds ([6 x i8]* @.str.2.18, i32 0, i32 0), i8 101 }, %struct.CTE { i8* getelementptr inbounds ([11 x i8]* @.str.3.19, i32 0, i32 0), i8 102 }, %struct.CTE { i8* getelementptr inbounds ([8 x i8]* @.str.4.20, i32 0, i32 0), i8 109 }, %struct.CTE { i8* getelementptr inbounds ([11 x i8]* @.str.5.21, i32 0, i32 0), i8 99 }, %struct.CTE { i8* getelementptr inbounds ([10 x i8]* @.str.6.22, i32 0, i32 0), i8 100 }, %struct.CTE { i8* getelementptr inbounds ([10 x i8]* @.str.7.23, i32 0, i32 0), i8 106 }, %struct.CTE { i8* getelementptr inbounds ([10 x i8]* @.str.8.24, i32 0, i32 0), i8 104 }, %struct.CTE { i8* getelementptr inbounds ([8 x i8]* @.str.9.25, i32 0, i32 0), i8 105 }, %struct.CTE { i8* getelementptr inbounds ([14 x i8]* @.str.10.26, i32 0, i32 0), i8 107 }, %struct.CTE { i8* getelementptr inbounds ([9 x i8]* @.str.11.27, i32 0, i32 0), i8 103 }, %struct.CTE { i8* getelementptr inbounds ([11 x i8]* @.str.12.28, i32 0, i32 0), i8 108 }, %struct.CTE { i8* getelementptr inbounds ([8 x i8]* @.str.13.29, i32 0, i32 0), i8 110 }, %struct.CTE { i8* getelementptr inbounds ([10 x i8]* @.str.14.30, i32 0, i32 0), i8 111 }, %struct.CTE { i8* getelementptr inbounds ([11 x i8]* @.str.15.31, i32 0, i32 0), i8 112 }, %struct.CTE { i8* getelementptr inbounds ([9 x i8]* @.str.16.32, i32 0, i32 0), i8 113 }, %struct.CTE { i8* getelementptr inbounds ([12 x i8]* @.str.17, i32 0, i32 0), i8 116 }, %struct.CTE { i8* getelementptr inbounds ([12 x i8]* @.str.18, i32 0, i32 0), i8 114 }, %struct.CTE { i8* getelementptr inbounds ([6 x i8]* @.str.19, i32 0, i32 0), i8 117 }, %struct.CTE { i8* getelementptr inbounds ([10 x i8]* @.str.20, i32 0, i32 0), i8 118 }, %struct.CTE { i8* getelementptr inbounds ([10 x i8]* @.str.21, i32 0, i32 0), i8 119 }, %struct.CTE { i8* getelementptr inbounds ([7 x i8]* @.str.22, i32 0, i32 0), i8 115 }, %struct.CTE { i8* getelementptr inbounds ([8 x i8]* @.str.23, i32 0, i32 0), i8 120 }, %struct.CTE { i8* getelementptr inbounds ([11 x i8]* @.str.24, i32 0, i32 0), i8 121 }, %struct.CTE { i8* getelementptr inbounds ([10 x i8]* @.str.25, i32 0, i32 0), i8 122 }, %struct.CTE { i8* getelementptr inbounds ([13 x i8]* @.str.26, i32 0, i32 0), i8 57 }, %struct.CTE { i8* getelementptr inbounds ([10 x i8]* @.str.27, i32 0, i32 0), i8 49 }, %struct.CTE { i8* getelementptr inbounds ([6 x i8]* @.str.28, i32 0, i32 0), i8 50 }, %struct.CTE { i8* getelementptr inbounds ([7 x i8]* @.str.29, i32 0, i32 0), i8 51 }, %struct.CTE { i8* getelementptr inbounds ([5 x i8]* @.str.30, i32 0, i32 0), i8 52 }, %struct.CTE { i8* getelementptr inbounds ([11 x i8]* @.str.31, i32 0, i32 0), i8 53 }, %struct.CTE { i8* getelementptr inbounds ([9 x i8]* @.str.32, i32 0, i32 0), i8 54 }, %struct.CTE { i8* getelementptr inbounds ([9 x i8]* @.str.33, i32 0, i32 0), i8 55 }, %struct.CTE { i8* getelementptr inbounds ([12 x i8]* @.str.34, i32 0, i32 0), i8 56 }, %struct.CTE { i8* getelementptr inbounds ([12 x i8]* @.str.35, i32 0, i32 0), i8 64 }, %struct.CTE { i8* getelementptr inbounds ([14 x i8]* @.str.36, i32 0, i32 0), i8 35 }, %struct.CTE { i8* getelementptr inbounds ([13 x i8]* @.str.37, i32 0, i32 0), i8 36 }, %struct.CTE { i8* getelementptr inbounds ([8 x i8]* @.str.38, i32 0, i32 0), i8 42 }, %struct.CTE { i8* getelementptr inbounds ([7 x i8]* @.str.39, i32 0, i32 0), i8 43 }, %struct.CTE { i8* getelementptr inbounds ([6 x i8]* @.str.40, i32 0, i32 0), i8 37 }, %struct.CTE { i8* getelementptr inbounds ([2 x i8]* @.str.41, i32 0, i32 0), i8 48 }], align 16
@stdout = external global %struct._IO_FILE*, align 8
@.str.42 = private unnamed_addr constant [15 x i8] c"\0AEnvironment:\0A\00", align 1
@.str.43 = private unnamed_addr constant [24 x i8] c"\09Eye pos:   \09 %f %f %f\0A\00", align 1
@.str.44 = private unnamed_addr constant [24 x i8] c"\09Center pos:\09 %f %f %f\0A\00", align 1
@.str.45 = private unnamed_addr constant [24 x i8] c"\09Background:\09 %f %f %f\0A\00", align 1
@.str.46 = private unnamed_addr constant [18 x i8] c"\09View Angle:\09 %f\0A\00", align 1
@.str.47 = private unnamed_addr constant [28 x i8] c"\0AAmbient Light:\09\09 %f %f %f\0A\00", align 1
@.str.48 = private unnamed_addr constant [10 x i8] c"\0ALights:\0A\00", align 1
@.str.49 = private unnamed_addr constant [23 x i8] c"\09[%ld] Pos:\09 %f %f %f\0A\00", align 1
@.str.50 = private unnamed_addr constant [21 x i8] c"\09    Col:\09 %f %f %f\0A\00", align 1
@.str.51 = private unnamed_addr constant [19 x i8] c"\09    Shadow:\09 %ld\0A\00", align 1
@.str.52 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.53 = private unnamed_addr constant [10 x i8] c"Options:\0A\00", align 1
@.str.54 = private unnamed_addr constant [15 x i8] c"\09Traversal:\09\09\09\00", align 1
@.str.55 = private unnamed_addr constant [6 x i8] c"list\0A\00", align 1
@.str.56 = private unnamed_addr constant [24 x i8] c"uniform grid hierarchy\0A\00", align 1
@.str.57 = private unnamed_addr constant [26 x i8] c"\09\09\09\09\09   grid size    %ld\0A\00", align 1
@.str.58 = private unnamed_addr constant [26 x i8] c"\09\09\09\09\09   max prims    %ld\0A\00", align 1
@.str.59 = private unnamed_addr constant [26 x i8] c"\09\09\09\09\09   max sublevel %ld\0A\00", align 1
@.str.60 = private unnamed_addr constant [26 x i8] c"\09\09\09\09\09   buckets      %ld\0A\00", align 1
@.str.61 = private unnamed_addr constant [26 x i8] c"\09\09\09\09\09   lazy         %ld\0A\00", align 1
@.str.62 = private unnamed_addr constant [21 x i8] c"\09Normalization DB:\09\09\00", align 1
@.str.63 = private unnamed_addr constant [5 x i8] c"yes\0A\00", align 1
@.str.64 = private unnamed_addr constant [4 x i8] c"no\0A\00", align 1
@.str.65 = private unnamed_addr constant [20 x i8] c"\09Projection type:\09\09\00", align 1
@.str.66 = private unnamed_addr constant [13 x i8] c"perspective\0A\00", align 1
@.str.67 = private unnamed_addr constant [14 x i8] c"orthographic\0A\00", align 1
@.str.68 = private unnamed_addr constant [13 x i8] c"\09Shadows:\09\09\09\00", align 1
@.str.69 = private unnamed_addr constant [4 x i8] c"on\0A\00", align 1
@.str.70 = private unnamed_addr constant [5 x i8] c"off\0A\00", align 1
@.str.71 = private unnamed_addr constant [13 x i8] c"\09Shading:\09\09\09\00", align 1
@.str.72 = private unnamed_addr constant [24 x i8] c"\09Resolution:\09\09\09%ld %ld\0A\00", align 1
@.str.73 = private unnamed_addr constant [23 x i8] c"\09Min Ray Weight:\09\09\09%f\0A\00", align 1
@.str.74 = private unnamed_addr constant [33 x i8] c"\09Max Anti Subdivison Level:\09%ld\0A\00", align 1
@.str.75 = private unnamed_addr constant [23 x i8] c"\09Anti tolerance:\09\09\09%f\0A\00", align 1
@.str.76 = private unnamed_addr constant [21 x i8] c"\09Bundle: \09\09\09%ld %ld\0A\00", align 1
@.str.77 = private unnamed_addr constant [21 x i8] c"\09Block:  \09\09\09%ld %ld\0A\00", align 1
@.str.78 = private unnamed_addr constant [22 x i8] c"\09Geometry file:\09\09\09%s\0A\00", align 1
@.str.79 = private unnamed_addr constant [19 x i8] c"\09Image file:\09\09\09%s\0A\00", align 1
@.str.80 = private unnamed_addr constant [6 x i8] c"env.c\00", align 1
@.str.81 = private unnamed_addr constant [25 x i8] c"Invalid color %f %f %f.\0A\00", align 1
@.str.82 = private unnamed_addr constant [30 x i8] c"\0A\0AInvalid command string %s.\0A\00", align 1
@.str.83 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@.str.84 = private unnamed_addr constant [37 x i8] c"Unable to open environment file %s.\0A\00", align 1
@.str.85 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.86 = private unnamed_addr constant [12 x i8] c"%lf %lf %lf\00", align 1
@.str.87 = private unnamed_addr constant [22 x i8] c"error: eye position.\0A\00", align 1
@.str.88 = private unnamed_addr constant [22 x i8] c"error: coi position.\0A\00", align 1
@.str.89 = private unnamed_addr constant [26 x i8] c"error: background color.\0A\00", align 1
@.str.90 = private unnamed_addr constant [4 x i8] c"%lf\00", align 1
@.str.91 = private unnamed_addr constant [23 x i8] c"error: viewing angle.\0A\00", align 1
@.str.92 = private unnamed_addr constant [19 x i8] c"Invalid angle %f.\0A\00", align 1
@.str.93 = private unnamed_addr constant [17 x i8] c"error: ambient.\0A\00", align 1
@.str.94 = private unnamed_addr constant [4 x i8] c"%ld\00", align 1
@.str.95 = private unnamed_addr constant [30 x i8] c"View error: antialias level.\0A\00", align 1
@.str.96 = private unnamed_addr constant [29 x i8] c"error: antialias level %ld.\0A\00", align 1
@.str.97 = private unnamed_addr constant [32 x i8] c"maxlevel of ray recursion = %d\0A\00", align 1
@.str.98 = private unnamed_addr constant [25 x i8] c"error: recursion level.\0A\00", align 1
@.str.99 = private unnamed_addr constant [29 x i8] c"error: recursion level %ld.\0A\00", align 1
@.str.100 = private unnamed_addr constant [29 x i8] c"error: miniumum ray weight.\0A\00", align 1
@.str.101 = private unnamed_addr constant [31 x i8] c"error: invalid ray weight %f.\0A\00", align 1
@.str.102 = private unnamed_addr constant [31 x i8] c"error: anti tolerance weight.\0A\00", align 1
@.str.103 = private unnamed_addr constant [42 x i8] c"error: invalid anti tolerance weight %f.\0A\00", align 1
@.str.104 = private unnamed_addr constant [8 x i8] c"%ld %ld\00", align 1
@.str.105 = private unnamed_addr constant [20 x i8] c"error: resolution.\0A\00", align 1
@.str.106 = private unnamed_addr constant [24 x i8] c"%lf %lf %lf %lf %lf %lf\00", align 1
@.str.107 = private unnamed_addr constant [16 x i8] c"error: Lights.\0A\00", align 1
@.str.108 = private unnamed_addr constant [33 x i8] c"error: Lights shadow indicator.\0A\00", align 1
@.str.109 = private unnamed_addr constant [18 x i8] c"Error in matrix.\0A\00", align 1
@.str.110 = private unnamed_addr constant [16 x i8] c"error: shadow.\0A\00", align 1
@.str.111 = private unnamed_addr constant [3 x i8] c"on\00", align 1
@.str.112 = private unnamed_addr constant [20 x i8] c"error: shading %s.\0A\00", align 1
@.str.113 = private unnamed_addr constant [23 x i8] c"error: projection %s.\0A\00", align 1
@.str.114 = private unnamed_addr constant [12 x i8] c"perspective\00", align 1
@.str.115 = private unnamed_addr constant [13 x i8] c"orthographic\00", align 1
@.str.116 = private unnamed_addr constant [24 x i8] c"Invalid projection %s.\0A\00", align 1
@.str.117 = private unnamed_addr constant [22 x i8] c"error: traversal %s.\0A\00", align 1
@.str.118 = private unnamed_addr constant [5 x i8] c"list\00", align 1
@.str.119 = private unnamed_addr constant [9 x i8] c"huniform\00", align 1
@.str.120 = private unnamed_addr constant [28 x i8] c"Invalid traversal code %s.\0A\00", align 1
@.str.121 = private unnamed_addr constant [4 x i8] c" %s\00", align 1
@.str.122 = private unnamed_addr constant [23 x i8] c"error: geometry file.\0A\00", align 1
@.str.123 = private unnamed_addr constant [24 x i8] c"error: runlength file.\0A\00", align 1
@.str.124 = private unnamed_addr constant [24 x i8] c"error: Preview bkcull.\0A\00", align 1
@.str.125 = private unnamed_addr constant [22 x i8] c"error: Preview fill.\0A\00", align 1
@.str.126 = private unnamed_addr constant [21 x i8] c"error: sphere tess.\0A\00", align 1
@.str.127 = private unnamed_addr constant [23 x i8] c"error: norm database.\0A\00", align 1
@.str.128 = private unnamed_addr constant [3 x i8] c"no\00", align 1
@.str.129 = private unnamed_addr constant [18 x i8] c"error: datatype.\0A\00", align 1
@.str.130 = private unnamed_addr constant [7 x i8] c"binary\00", align 1
@.str.131 = private unnamed_addr constant [33 x i8] c"error: Huniform prims per cell.\0A\00", align 1
@.str.132 = private unnamed_addr constant [27 x i8] c"error: Huniform gridsize.\0A\00", align 1
@.str.133 = private unnamed_addr constant [29 x i8] c"error: Huniform numbuckets.\0A\00", align 1
@.str.134 = private unnamed_addr constant [35 x i8] c"error: Huniform max subdiv level.\0A\00", align 1
@.str.135 = private unnamed_addr constant [23 x i8] c"error: Huniform lazy.\0A\00", align 1
@.str.136 = private unnamed_addr constant [16 x i8] c"error: bundle.\0A\00", align 1
@.str.137 = private unnamed_addr constant [15 x i8] c"error: block.\0A\00", align 1
@.str.138 = private unnamed_addr constant [40 x i8] c"Warning: unrecognized env command: %s.\0A\00", align 1
@.str.139 = private unnamed_addr constant [54 x i8] c"Data must be normalized with this traversal method!.\0A\00", align 1
@.str.16 = private unnamed_addr constant [4 x i8] c"eye\00", align 1
@.str.1.17 = private unnamed_addr constant [7 x i8] c"center\00", align 1
@.str.2.18 = private unnamed_addr constant [6 x i8] c"light\00", align 1
@.str.3.19 = private unnamed_addr constant [11 x i8] c"resolution\00", align 1
@.str.4.20 = private unnamed_addr constant [8 x i8] c"shadows\00", align 1
@.str.5.21 = private unnamed_addr constant [11 x i8] c"background\00", align 1
@.str.6.22 = private unnamed_addr constant [10 x i8] c"viewangle\00", align 1
@.str.7.23 = private unnamed_addr constant [10 x i8] c"antilevel\00", align 1
@.str.8.24 = private unnamed_addr constant [10 x i8] c"minweight\00", align 1
@.str.9.25 = private unnamed_addr constant [8 x i8] c"project\00", align 1
@.str.10.26 = private unnamed_addr constant [14 x i8] c"antitolerance\00", align 1
@.str.11.27 = private unnamed_addr constant [9 x i8] c"maxlevel\00", align 1
@.str.12.28 = private unnamed_addr constant [11 x i8] c"modelxform\00", align 1
@.str.13.29 = private unnamed_addr constant [8 x i8] c"shading\00", align 1
@.str.14.30 = private unnamed_addr constant [10 x i8] c"displayin\00", align 1
@.str.15.31 = private unnamed_addr constant [11 x i8] c"displayout\00", align 1
@.str.16.32 = private unnamed_addr constant [9 x i8] c"geometry\00", align 1
@.str.17 = private unnamed_addr constant [12 x i8] c"texturetype\00", align 1
@.str.18 = private unnamed_addr constant [12 x i8] c"texturefile\00", align 1
@.str.19 = private unnamed_addr constant [6 x i8] c"image\00", align 1
@.str.20 = private unnamed_addr constant [10 x i8] c"footprint\00", align 1
@.str.21 = private unnamed_addr constant [10 x i8] c"traversal\00", align 1
@.str.22 = private unnamed_addr constant [7 x i8] c"rlfile\00", align 1
@.str.23 = private unnamed_addr constant [8 x i8] c"ambient\00", align 1
@.str.24 = private unnamed_addr constant [11 x i8] c"excellprim\00", align 1
@.str.25 = private unnamed_addr constant [10 x i8] c"excelldir\00", align 1
@.str.26 = private unnamed_addr constant [13 x i8] c"excellsubdiv\00", align 1
@.str.27 = private unnamed_addr constant [10 x i8] c"hsublevel\00", align 1
@.str.28 = private unnamed_addr constant [6 x i8] c"hprim\00", align 1
@.str.29 = private unnamed_addr constant [7 x i8] c"bfcull\00", align 1
@.str.30 = private unnamed_addr constant [5 x i8] c"fill\00", align 1
@.str.31 = private unnamed_addr constant [11 x i8] c"spheretess\00", align 1
@.str.32 = private unnamed_addr constant [9 x i8] c"normdata\00", align 1
@.str.33 = private unnamed_addr constant [9 x i8] c"datatype\00", align 1
@.str.34 = private unnamed_addr constant [12 x i8] c"hu_maxprims\00", align 1
@.str.35 = private unnamed_addr constant [12 x i8] c"hu_gridsize\00", align 1
@.str.36 = private unnamed_addr constant [14 x i8] c"hu_numbuckets\00", align 1
@.str.37 = private unnamed_addr constant [13 x i8] c"hu_maxsubdiv\00", align 1
@.str.38 = private unnamed_addr constant [8 x i8] c"hu_lazy\00", align 1
@.str.39 = private unnamed_addr constant [7 x i8] c"bundle\00", align 1
@.str.40 = private unnamed_addr constant [6 x i8] c"block\00", align 1
@.str.41 = private unnamed_addr constant [2 x i8] c" \00", align 1
@image = internal global [1280 x %struct.anon] zeroinitializer, align 16
@.str.140 = private unnamed_addr constant [9 x i8] c"%c%c%c%c\00", align 1
@.str.1.141 = private unnamed_addr constant [7 x i8] c"fbuf.c\00", align 1
@.str.2.142 = private unnamed_addr constant [3 x i8] c"wb\00", align 1
@.str.3.143 = private unnamed_addr constant [33 x i8] c"Unable to open picture file %s.\0A\00", align 1
@.str.4.144 = private unnamed_addr constant [17 x i8] c"%c%c%c%c%c%c%c%c\00", align 1
@.str.145 = private unnamed_addr constant [12 x i8] c"Object  %s\0A\00", align 1
@.str.1.146 = private unnamed_addr constant [27 x i8] c"\09color  %f %f %f %f %f %f\0A\00", align 1
@.str.2.147 = private unnamed_addr constant [24 x i8] c"\09coeffs %f %f %f %f %f\0A\00", align 1
@.str.3.148 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@.str.4.149 = private unnamed_addr constant [31 x i8] c"Unable to open model file %s.\0A\00", align 1
@.str.5.150 = private unnamed_addr constant [37 x i8] c"Incorrect comment in geometry file.\0A\00", align 1
@.str.6.151 = private unnamed_addr constant [6 x i8] c"%s %s\00", align 1
@.str.7.152 = private unnamed_addr constant [7 x i8] c"object\00", align 1
@.str.8.153 = private unnamed_addr constant [31 x i8] c"Invalid object definition %s.\0A\00", align 1
@.str.9.154 = private unnamed_addr constant [6 x i8] c"geo.c\00", align 1
@.str.10.155 = private unnamed_addr constant [24 x i8] c"%lf %lf %lf %lf %lf %lf\00", align 1
@.str.11.156 = private unnamed_addr constant [25 x i8] c"Object color incorrect.\0A\00", align 1
@.str.12.157 = private unnamed_addr constant [20 x i8] c"%lf %lf %lf %lf %lf\00", align 1
@.str.13.158 = private unnamed_addr constant [40 x i8] c"Object surface coefficients incorrect.\0A\00", align 1
@.str.14.159 = private unnamed_addr constant [17 x i8] c"%ld %ld %ld %ld\0A\00", align 1
@.str.15.160 = private unnamed_addr constant [50 x i8] c"Texture and/or flag information not all present.\0A\00", align 1
@.str.16.161 = private unnamed_addr constant [7 x i8] c"%c %ld\00", align 1
@.str.17.162 = private unnamed_addr constant [26 x i8] c"Object primitive opcode.\0A\00", align 1
@SphProcs = internal global %struct.pprocs { i8* (...)* bitcast (i8* ()* @SphName to i8* (...)*), void (...)* bitcast (void (%struct.object*)* @SphPrint to void (...)*), void (...)* bitcast (void (%struct.object*, %struct._IO_FILE*)* @SphRead to void (...)*), void (...)* null, void (...)* bitcast (void (%struct.object*, [4 x double]*, [4 x double]*)* @SphTransform to void (...)*), i64 (...)* bitcast (i64 (%struct.ray*, %struct.object*, %struct.irecord*)* @SphIntersect to i64 (...)*), i64 (...)* bitcast (i64 (%struct.ray*, %struct.element*, %struct.irecord*)* @SphPeIntersect to i64 (...)*), void (...)* bitcast (void (%struct.irecord*, double*, double*)* @SphNormal to void (...)*), void (...)* bitcast (void (%struct.object*, [4 x double]*)* @SphDataNormalize to void (...)*), void (...)* bitcast (void (%struct.object*)* @SphBoundBox to void (...)*) }, align 8
@PolyProcs = internal global %struct.pprocs { i8* (...)* bitcast (i8* ()* @PolyName to i8* (...)*), void (...)* bitcast (void (%struct.object*)* @PolyPrint to void (...)*), void (...)* bitcast (void (%struct.object*, %struct._IO_FILE*)* @PolyRead to void (...)*), void (...)* null, void (...)* bitcast (void (%struct.object*, [4 x double]*, [4 x double]*)* @PolyTransform to void (...)*), i64 (...)* bitcast (i64 (%struct.ray*, %struct.object*, %struct.irecord*)* @PolyIntersect to i64 (...)*), i64 (...)* bitcast (i64 (%struct.ray*, %struct.element*, %struct.irecord*)* @PolyPeIntersect to i64 (...)*), void (...)* bitcast (void (%struct.irecord*, double*, double*)* @PolyNormal to void (...)*), void (...)* bitcast (void (%struct.object*, [4 x double]*)* @PolyDataNormalize to void (...)*), void (...)* bitcast (void (%struct.object*)* @PolyBoundBox to void (...)*) }, align 8
@TriProcs = internal global %struct.pprocs { i8* (...)* bitcast (i8* ()* @TriName to i8* (...)*), void (...)* bitcast (void (%struct.object*)* @TriPrint to void (...)*), void (...)* bitcast (void (%struct.object*, %struct._IO_FILE*)* @TriRead to void (...)*), void (...)* null, void (...)* bitcast (void (%struct.object*, [4 x double]*, [4 x double]*)* @TriTransform to void (...)*), i64 (...)* bitcast (i64 (%struct.ray*, %struct.object*, %struct.irecord*)* @TriIntersect to i64 (...)*), i64 (...)* bitcast (i64 (%struct.ray*, %struct.element*, %struct.irecord*)* @TriPeIntersect to i64 (...)*), void (...)* bitcast (void (%struct.irecord*, double*, double*)* @TriNormal to void (...)*), void (...)* bitcast (void (%struct.object*, [4 x double]*)* @TriDataNormalize to void (...)*), void (...)* bitcast (void (%struct.object*)* @TriBoundBox to void (...)*) }, align 8
@.str.18.163 = private unnamed_addr constant [54 x i8] c"Code for cylinders and quadrics not implemented yet.\0A\00", align 1
@.str.19.164 = private unnamed_addr constant [30 x i8] c"Invalid primitive type '%c'.\0A\00", align 1
@.str.167 = private unnamed_addr constant [28 x i8] c"    Print Voxel  id = %ld \0A\00", align 1
@.str.1.168 = private unnamed_addr constant [23 x i8] c"        celltype %ld \0A\00", align 1
@.str.2.169 = private unnamed_addr constant [20 x i8] c"        gsm_voxel \0A\00", align 1
@.str.3.170 = private unnamed_addr constant [33 x i8] c"        primElement index list:\0A\00", align 1
@.str.4.171 = private unnamed_addr constant [18 x i8] c"            %ld \0A\00", align 1
@.str.5.172 = private unnamed_addr constant [26 x i8] c"        gsm_grid id %ld \0A\00", align 1
@.str.6.173 = private unnamed_addr constant [16 x i8] c"    End Voxel \0A\00", align 1
@.str.7.174 = private unnamed_addr constant [22 x i8] c"    Print  Grid %ld \0A\00", align 1
@.str.8.175 = private unnamed_addr constant [26 x i8] c"        num_prims = %ld \0A\00", align 1
@.str.9.176 = private unnamed_addr constant [42 x i8] c"        indx_inc[0,1,2] = %ld, %ld, %ld \0A\00", align 1
@.str.10.177 = private unnamed_addr constant [28 x i8] c"        num_buckets = %ld \0A\00", align 1
@.str.11.178 = private unnamed_addr constant [37 x i8] c"        min[0,1,2] = %lf, %lf, %lf \0A\00", align 1
@.str.12.179 = private unnamed_addr constant [42 x i8] c"        cellsize[0,1,2] = %lf, %lf, %lf \0A\00", align 1
@.str.13.180 = private unnamed_addr constant [29 x i8] c"        subdiv_level = %ld \0A\00", align 1
@.str.14.181 = private unnamed_addr constant [27 x i8] c"        next grid id %ld \0A\00", align 1
@.str.15.182 = private unnamed_addr constant [28 x i8] c"        next grid id NULL \0A\00", align 1
@.str.16.183 = private unnamed_addr constant [17 x i8] c"    Voxel List \0A\00", align 1
@.str.17.184 = private unnamed_addr constant [30 x i8] c"        Voxel %ld is empty. \0A\00", align 1
@.str.18.185 = private unnamed_addr constant [15 x i8] c"    End Grid \0A\00", align 1
@.str.19.186 = private unnamed_addr constant [24 x i8] c"    Print Ray  id %ld \0A\00", align 1
@.str.20.187 = private unnamed_addr constant [43 x i8] c"        origin:        ( %lf, %lf, %lf ) \0A\00", align 1
@.str.21.188 = private unnamed_addr constant [43 x i8] c"        direction:     ( %lf, %lf, %lf ) \0A\00", align 1
@.str.22.189 = private unnamed_addr constant [48 x i8] c"        indx_inc3D[0,1,2] = [ %ld, %ld, %ld ] \0A\00", align 1
@.str.23.190 = private unnamed_addr constant [24 x i8] c"        ri_indx = %ld \0A\00", align 1
@.str.24.191 = private unnamed_addr constant [19 x i8] c"        rayinfo: \0A\00", align 1
@.str.25.192 = private unnamed_addr constant [33 x i8] c"            ray is in grid %ld \0A\00", align 1
@.str.26.193 = private unnamed_addr constant [43 x i8] c"            d[0,1,2] = [ %lf, %lf, %lf ] \0A\00", align 1
@.str.27.194 = private unnamed_addr constant [30 x i8] c"            entry_plane %ld \0A\00", align 1
@.str.28.195 = private unnamed_addr constant [25 x i8] c"            t_in = %lf \0A\00", align 1
@.str.29.196 = private unnamed_addr constant [29 x i8] c"            exit_plane %ld \0A\00", align 1
@.str.30.197 = private unnamed_addr constant [26 x i8] c"            t_out = %lf \0A\00", align 1
@.str.31.198 = private unnamed_addr constant [47 x i8] c"            delta[0,1,2] = [ %lf, %lf, %lf ] \0A\00", align 1
@.str.32.199 = private unnamed_addr constant [49 x i8] c"            index3D[0,1,2] = [ %ld, %ld, %ld ] \0A\00", align 1
@.str.33.200 = private unnamed_addr constant [28 x i8] c"            index1D = %ld \0A\00", align 1
@.str.34.201 = private unnamed_addr constant [52 x i8] c"            indx_inc1D[0,1,2] = [ %ld, %ld, %ld ] \0A\00", align 1
@.str.35.202 = private unnamed_addr constant [14 x i8] c"    End Ray \0A\00", align 1
@.str.36.203 = private unnamed_addr constant [33 x i8] c"%s: prn_PrimElem: Null pointer.\0A\00", align 1
@.str.37.204 = private unnamed_addr constant [58 x i8] c"PrimElem: index %ld  ptr %lu, PrimObj index %ld ptr %lu \0A\00", align 1
@.str.38.205 = private unnamed_addr constant [60 x i8] c"   BBox: ( %lf, %lf, %lf ) -> \0A         ( %lf, %lf, %lf ) \0A\00", align 1
@.str.39.206 = private unnamed_addr constant [16 x i8] c"Bintree node: \0A\00", align 1
@.str.40.207 = private unnamed_addr constant [42 x i8] c"    indecies of cell: ( %ld, %ld, %ld ) \0A\00", align 1
@.str.41.208 = private unnamed_addr constant [35 x i8] c"    gridsizes: ( %ld, %ld, %ld ) \0A\00", align 1
@.str.42.209 = private unnamed_addr constant [38 x i8] c"    minimum point ( %lf, %lf, %lf ) \0A\00", align 1
@.str.43.210 = private unnamed_addr constant [22 x i8] c"    subdiv axis %ld \0A\00", align 1
@.str.44.211 = private unnamed_addr constant [31 x i8] c"    number of primitives %ld \0A\00", align 1
@.str.45.212 = private unnamed_addr constant [30 x i8] c"    Primitive element list: \0A\00", align 1
@.str.46.213 = private unnamed_addr constant [6 x i8] c"  %ld\00", align 1
@.str.47.214 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.48.215 = private unnamed_addr constant [27 x i8] c"\0A    End of bintree node \0A\00", align 1
@.str.216 = private unnamed_addr constant [26 x i8] c"Uniform Hierarchy built.\0A\00", align 1
@eps_t = internal global double 1.000000e-10, align 8
@.str.225 = private unnamed_addr constant [18 x i8] c"hashtable error \0A\00", align 1
@.str.1.226 = private unnamed_addr constant [42 x i8] c"push_down_grid: Ray origin not in voxel \0A\00", align 1
@ProgName = internal global i8* getelementptr inbounds ([9 x i8]* @.str.267, i32 0, i32 0), align 8
@nprocs = internal global i64 1, align 8
@MaxGlobMem = internal global i64 32, align 8
@NumSubRays = internal global i64 1, align 8
@dostats = internal global i64 0, align 8
@.str.1.231 = private unnamed_addr constant [26 x i8] c"%s - parallel ray tracer\0A\00", align 1
@.str.2.232 = private unnamed_addr constant [13 x i8] c"Version %s\0A\0A\00", align 1
@.str.3.233 = private unnamed_addr constant [5 x i8] c"1.00\00", align 1
@.str.4.234 = private unnamed_addr constant [30 x i8] c"Usage:\09%s [options] envfile\0A\0A\00", align 1
@.str.5.235 = private unnamed_addr constant [31 x i8] c"\09-h\09Print this usage message.\0A\00", align 1
@.str.6.236 = private unnamed_addr constant [136 x i8] c"\09-a<n>\09Enable antialiasing with n subpixels (default = 1).\0A\09When using with SPLASH suite for evaluation, use default (no antialiasing)\0A\00", align 1
@.str.7.237 = private unnamed_addr constant [61 x i8] c"\09-m<n>\09Request n megabytes of global memory (default = 32).\0A\00", align 1
@.str.8.238 = private unnamed_addr constant [43 x i8] c"\09-p<n>\09Run on n processors (default = 1).\0A\00", align 1
@.str.9.239 = private unnamed_addr constant [55 x i8] c"\09-s\09Measure and print per-process timing information.\0A\00", align 1
@.str.10.240 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.11.241 = private unnamed_addr constant [26 x i8] c"%s: Invalid option '%c'.\0A\00", align 1
@.str.12.242 = private unnamed_addr constant [46 x i8] c"%s: Valid range for #processors is [1, %ld].\0A\00", align 1
@.str.13.243 = private unnamed_addr constant [32 x i8] c"Number of processors:     \09%ld\0A\00", align 1
@.str.14.244 = private unnamed_addr constant [35 x i8] c"Global shared memory size:\09%ld MB\0A\00", align 1
@.str.15.245 = private unnamed_addr constant [32 x i8] c"Samples per pixel:        \09%ld\0A\00", align 1
@.str.16.246 = private unnamed_addr constant [36 x i8] c"%s: Cannot initialize global heap.\0A\00", align 1
@.str.17.247 = private unnamed_addr constant [35 x i8] c"Number of primitive objects: \09%ld\0A\00", align 1
@.str.18.248 = private unnamed_addr constant [35 x i8] c"Number of primitive elements:\09%ld\0A\00", align 1
@.str.19.249 = private unnamed_addr constant [45 x i8] c"TIMING STATISTICS MEASURED BY MAIN PROCESS:\0A\00", align 1
@.str.20.250 = private unnamed_addr constant [38 x i8] c"        Overall start time     %20lu\0A\00", align 1
@.str.21.251 = private unnamed_addr constant [34 x i8] c"        Overall end time   %20lu\0A\00", align 1
@.str.22.252 = private unnamed_addr constant [47 x i8] c"        Total time with initialization  %20lu\0A\00", align 1
@.str.23.253 = private unnamed_addr constant [50 x i8] c"        Total time without initialization  %20lu\0A\00", align 1
@.str.24.254 = private unnamed_addr constant [28 x i8] c"\0A\0A\0APER-PROCESS STATISTICS:\0A\00", align 1
@.str.25.255 = private unnamed_addr constant [10 x i8] c"%20s%20s\0A\00", align 1
@.str.26.256 = private unnamed_addr constant [5 x i8] c"Proc\00", align 1
@.str.27.257 = private unnamed_addr constant [5 x i8] c"Time\00", align 1
@.str.28.258 = private unnamed_addr constant [11 x i8] c"%20s%20s\0A\0A\00", align 1
@.str.29.259 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.30.260 = private unnamed_addr constant [13 x i8] c"Tracing Rays\00", align 1
@.str.31.261 = private unnamed_addr constant [10 x i8] c"%20d%20d\0A\00", align 1
@.str.32.262 = private unnamed_addr constant [12 x i8] c"\0A\0A%20s%20d\0A\00", align 1
@.str.33.263 = private unnamed_addr constant [7 x i8] c"Max = \00", align 1
@.str.34.264 = private unnamed_addr constant [10 x i8] c"%20s%20d\0A\00", align 1
@.str.35.265 = private unnamed_addr constant [7 x i8] c"Min = \00", align 1
@.str.36.266 = private unnamed_addr constant [7 x i8] c"Avg = \00", align 1
@.str.267 = private unnamed_addr constant [9 x i8] c"RAYTRACE\00", align 1
@.str.286 = private unnamed_addr constant [5 x i8] c"\0A%s\0A\00", align 1
@.str.1.287 = private unnamed_addr constant [2 x i8] c"\09\00", align 1
@.str.2.288 = private unnamed_addr constant [5 x i8] c"%f  \00", align 1
@.str.3.289 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.4.290 = private unnamed_addr constant [28 x i8] c"Unknown rotation axis %ld.\0A\00", align 1
@begmem = internal global %struct.node* null, align 8
@endmem = internal global %struct.node* null, align 8
@nodesize = internal global i64 0, align 8
@mem_grid = internal global i64 0, align 8
@maxmem_grid = internal global i64 0, align 8
@mem_voxel = internal global i64 0, align 8
@maxmem_voxel = internal global i64 0, align 8
@mem_hashtable = internal global i64 0, align 8
@maxmem_hashtable = internal global i64 0, align 8
@mem_emptycells = internal global i64 0, align 8
@maxmem_emptycells = internal global i64 0, align 8
@mem_bintree = internal global i64 0, align 8
@maxmem_bintree = internal global i64 0, align 8
@mem_pepArray = internal global i64 0, align 8
@maxmem_pepArray = internal global i64 0, align 8
@.str.307 = private unnamed_addr constant [38 x i8] c"%s: %s cannot allocate local memory.\0A\00", align 1
@.str.1.308 = private unnamed_addr constant [22 x i8] c"freelist ->\090x%08lX\0A\0A\00", align 1
@.str.2.309 = private unnamed_addr constant [56 x i8] c"node addr \09node->next\09node->size\09node->free\09node->cksm\0A\00", align 1
@.str.3.310 = private unnamed_addr constant [56 x i8] c"==========\09==========\09==========\09==========\09==========\0A\00", align 1
@.str.5.311 = private unnamed_addr constant [5 x i8] c"FREE\00", align 1
@.str.6.312 = private unnamed_addr constant [5 x i8] c"    \00", align 1
@.str.4.313 = private unnamed_addr constant [35 x i8] c"0x%08lX\090x%08lX\09%10ld\09%s\09\090x%08lX\0A\00", align 1
@.str.7.314 = private unnamed_addr constant [43 x i8] c"GlobalHeapWalk: Invalid checksum in node.\0A\00", align 1
@.str.8.315 = private unnamed_addr constant [41 x i8] c"GlobalMalloc: Invalid checksum in node.\0A\00", align 1
@.str.9.316 = private unnamed_addr constant [53 x i8] c"GlobalMalloc: Node in free list not marked as free.\0A\00", align 1
@.str.10.317 = private unnamed_addr constant [39 x i8] c"%s: %s cannot allocate global memory.\0A\00", align 1
@.str.11.318 = private unnamed_addr constant [13 x i8] c"GlobalCalloc\00", align 1
@.str.12.319 = private unnamed_addr constant [14 x i8] c"GlobalRealloc\00", align 1
@.str.13.320 = private unnamed_addr constant [65 x i8] c"GlobalRealloc: Attempted to realloc node with invalid checksum.\0A\00", align 1
@.str.14.321 = private unnamed_addr constant [58 x i8] c"GlobalRealloc: Attempted to realloc an unallocated node.\0A\00", align 1
@.str.15.322 = private unnamed_addr constant [55 x i8] c"GlobalRealloc: Could not find next node in free list.\0A\00", align 1
@.str.16.323 = private unnamed_addr constant [59 x i8] c"GlobalFree: Attempted to free node with invalid checksum.\0A\00", align 1
@.str.17.324 = private unnamed_addr constant [49 x i8] c"GlobalFree: Attempted to free unallocated node.\0A\00", align 1
@.str.18.325 = private unnamed_addr constant [48 x i8] c"GlobalFree: Invalid checksum in previous node.\0A\00", align 1
@.str.19.326 = private unnamed_addr constant [74 x i8] c"freelist=0x%08lX, curr=0x%08lX, size=0x%08lX, pn=0x%08lX, endmem=0x%08lX\0A\00", align 1
@.str.20.327 = private unnamed_addr constant [63 x i8] c"GlobalFree: Search for previous block fell off end of memory.\0A\00", align 1
@.str.21.328 = private unnamed_addr constant [44 x i8] c"GlobalFree: Invalid checksum in next node.\0A\00", align 1
@.str.22.329 = private unnamed_addr constant [5 x i8] c"GRID\00", align 1
@.str.23.330 = private unnamed_addr constant [6 x i8] c"VOXEL\00", align 1
@.str.24.331 = private unnamed_addr constant [10 x i8] c"HASHTABLE\00", align 1
@.str.25.332 = private unnamed_addr constant [11 x i8] c"EMPTYCELLS\00", align 1
@.str.26.333 = private unnamed_addr constant [8 x i8] c"BINTREE\00", align 1
@.str.27.334 = private unnamed_addr constant [9 x i8] c"PEPARRAY\00", align 1
@.str.28.335 = private unnamed_addr constant [39 x i8] c"ObjectMalloc: Unknown object type: %d\0A\00", align 1
@.str.29.336 = private unnamed_addr constant [37 x i8] c"ObjectFree: Unknown object type: %d\0A\00", align 1
@.str.30.337 = private unnamed_addr constant [19 x i8] c"error ma_rayinfo \0A\00", align 1
@.str.31.338 = private unnamed_addr constant [70 x i8] c"\0A****** Hierarchial uniform grid memory allocation summary ******* \0A\0A\00", align 1
@.str.32.339 = private unnamed_addr constant [70 x i8] c"     < struct >:            < current >   < maximum >    < sizeof > \0A\00", align 1
@.str.33.340 = private unnamed_addr constant [71 x i8] c"     <  bytes >:             <  bytes >   <   bytes >    <  bytes > \0A\0A\00", align 1
@.str.34.341 = private unnamed_addr constant [49 x i8] c"     grid:                %11ld   %11ld   %11d \0A\00", align 1
@.str.35.342 = private unnamed_addr constant [49 x i8] c"     hashtable entries:   %11ld   %11ld   %11d \0A\00", align 1
@.str.36.343 = private unnamed_addr constant [49 x i8] c"     emptycell entries:   %11ld   %11ld   %11d \0A\00", align 1
@.str.37.344 = private unnamed_addr constant [49 x i8] c"     voxel:               %11ld   %11ld   %11d \0A\00", align 1
@.str.38.345 = private unnamed_addr constant [49 x i8] c"     bintree_node:        %11ld   %11ld   %11d \0A\00", align 1
@.str.39.346 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.40.347 = private unnamed_addr constant [48 x i8] c"     Totals:              %11ld   %11ld      \0A\0A\00", align 1
@.str.366 = private unnamed_addr constant [5 x i8] c"poly\00", align 1
@.str.1.367 = private unnamed_addr constant [25 x i8] c"\09polygon: %ld polygons.\0A\00", align 1
@.str.2.368 = private unnamed_addr constant [40 x i8] c"\09\09Vertices: %ld  Plane eq: %f %f %f %f\0A\00", align 1
@.str.3.369 = private unnamed_addr constant [13 x i8] c"\09\09%f %f %f \0A\00", align 1
@.str.4.370 = private unnamed_addr constant [4 x i8] c"%ld\00", align 1
@.str.5.371 = private unnamed_addr constant [32 x i8] c"Error in PolyRead: totalverts.\0A\00", align 1
@.str.6.372 = private unnamed_addr constant [7 x i8] c"poly.c\00", align 1
@.str.7.373 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.8.374 = private unnamed_addr constant [43 x i8] c"Error in PolyRead: face normal indicator.\0A\00", align 1
@.str.9.375 = private unnamed_addr constant [12 x i8] c"%lf %lf %lf\00", align 1
@.str.10.376 = private unnamed_addr constant [32 x i8] c"Error in PolyRead: vertex %ld.\0A\00", align 1
@.str.11.377 = private unnamed_addr constant [34 x i8] c"Error in PolyRead: vertex count.\0A\00", align 1
@.str.12.378 = private unnamed_addr constant [45 x i8] c"Polygon vertex count, %ld, exceeds maximum.\0A\00", align 1
@.str.13.379 = private unnamed_addr constant [13 x i8] c" %lf %lf %lf\00", align 1
@.str.14.380 = private unnamed_addr constant [37 x i8] c"Error in PolyRead: face normal %ld.\0A\00", align 1
@.str.15.381 = private unnamed_addr constant [38 x i8] c"Error in PolyRead: vertex index %ld.\0A\00", align 1
@raystruct = internal global [128 x %struct.r_struct] zeroinitializer, align 16
@.str.384 = private unnamed_addr constant [11 x i8] c"raystack.c\00", align 1
@.str.1.385 = private unnamed_addr constant [30 x i8] c"%s: Ray tree stack overflow.\0A\00", align 1
@.str.404 = private unnamed_addr constant [7 x i8] c"sphere\00", align 1
@.str.1.405 = private unnamed_addr constant [16 x i8] c"\09Sphere object\0A\00", align 1
@.str.2.406 = private unnamed_addr constant [20 x i8] c"\09\09center  %f %f %f\0A\00", align 1
@.str.3.407 = private unnamed_addr constant [25 x i8] c"\09\09        radius %f %f\0A\0A\00", align 1
@.str.4.408 = private unnamed_addr constant [6 x i8] c"sph.c\00", align 1
@.str.5.409 = private unnamed_addr constant [16 x i8] c"%lf %lf %lf %lf\00", align 1
@.str.6.410 = private unnamed_addr constant [31 x i8] c"Error in SphRead: sphere %ld.\0A\00", align 1
@frand.lLastRand = internal global i64 0, align 8
@.str.429 = private unnamed_addr constant [5 x i8] c"poly\00", align 1
@.str.1.430 = private unnamed_addr constant [27 x i8] c"\09triangle: %ld triangles.\0A\00", align 1
@.str.2.431 = private unnamed_addr constant [39 x i8] c"\09\09Vertices: 3   Plane eq: %f %f %f %f\0A\00", align 1
@.str.3.432 = private unnamed_addr constant [13 x i8] c"\09\09%f %f %f \0A\00", align 1
@.str.4.433 = private unnamed_addr constant [4 x i8] c"%ld\00", align 1
@.str.5.434 = private unnamed_addr constant [31 x i8] c"Error in TriRead: totalverts.\0A\00", align 1
@.str.6.435 = private unnamed_addr constant [6 x i8] c"tri.c\00", align 1
@.str.7.436 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.8.437 = private unnamed_addr constant [42 x i8] c"Error in TriRead: face normal indicator.\0A\00", align 1
@.str.9.438 = private unnamed_addr constant [44 x i8] c"Error in TriRead: vertex normal indicator.\0A\00", align 1
@.str.10.439 = private unnamed_addr constant [12 x i8] c"%lf %lf %lf\00", align 1
@.str.11.440 = private unnamed_addr constant [31 x i8] c"Error in TriRead: vertex %ld.\0A\00", align 1
@.str.12.441 = private unnamed_addr constant [38 x i8] c"Error in TriRead: vertex normal %ld.\0A\00", align 1
@.str.13.442 = private unnamed_addr constant [13 x i8] c" %lf %lf %lf\00", align 1
@.str.14.443 = private unnamed_addr constant [36 x i8] c"Error in TriRead: face normal %ld.\0A\00", align 1
@.str.15.444 = private unnamed_addr constant [12 x i8] c"%ld %ld %ld\00", align 1
@.str.16.445 = private unnamed_addr constant [37 x i8] c"Error in TriRead: vertex index %ld.\0A\00", align 1
@.str.450 = private unnamed_addr constant [11 x i8] c"workpool.c\00", align 1
@.str.1.451 = private unnamed_addr constant [73 x i8] c"Workpool entry:    pid=%3ld    xs=%3ld    ys=%3ld    xe=%3ld    ye=%3ld\0A\00", align 1
@index_out = internal global i32 0, align 4
@gSyncVar_0 = internal global i32 0, align 4
@gSyncVar_1 = internal global i32 0, align 4
@gSyncVar_2 = internal global i32 0, align 4
@gSyncVarsTotalNum = internal global i32 0, align 4
@counter0 = internal global i32 0, align 4
@counter1 = internal global i32 0, align 4
@firstSync = internal global i8 1, align 1
@mystring = internal global [200 x i8] zeroinitializer, align 16
@switches = internal global [3 x i8] zeroinitializer, align 1
@syncID = internal global [3 x i32] zeroinitializer, align 4

; Function Attrs: nounwind uwtable
define internal void @InquireBoundBoxValues(%struct.bbox* %pbb, double* %minx, double* %miny, double* %minz, double* %maxx, double* %maxy, double* %maxz) {
entry:
  %pbb.addr = alloca %struct.bbox*, align 8
  %minx.addr = alloca double*, align 8
  %miny.addr = alloca double*, align 8
  %minz.addr = alloca double*, align 8
  %maxx.addr = alloca double*, align 8
  %maxy.addr = alloca double*, align 8
  %maxz.addr = alloca double*, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @NormalizeBoundBox(%struct.bbox* %pbb, [4 x double]* %mat) {
entry:
  %pbb.addr = alloca %struct.bbox*, align 8
  %mat.addr = alloca [4 x double]*, align 8
  %tmp = alloca [4 x double], align 16
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @prn_gridlist() {
entry:
  %g = alloca %struct.grid*, align 8
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  br label %while.end

while.body:                                       ; No predecessors!
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret void
}

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...)

; Function Attrs: nounwind uwtable
define internal void @prn_ds_stats() {
entry:
  %leafs = alloca i64, align 8
  %voxels = alloca i64, align 8
  ret void
}

declare i32 @printf(i8*, ...)

; Function Attrs: nounwind uwtable
define internal void @init_masks() {
entry:
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  store i64 64, i64* %n, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i64* %i, align 8
  %1 = load i64* %n, align 8
  %cmp = icmp slt i64 %0, %1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load i64* %i, align 8
  %shr = lshr i64 -9223372036854775808, %2
  %3 = load i64* %i, align 8
  %arrayidx = getelementptr inbounds [64 x i64]* @empty_masks, i32 0, i64 %3
  store i64 %shr, i64* %arrayidx, align 8
  %4 = load i64* %i, align 8
  %arrayidx1 = getelementptr inbounds [64 x i64]* @empty_masks, i32 0, i64 %4
  %5 = load i64* %arrayidx1, align 8
  %neg = xor i64 %5, -1
  %6 = load i64* %i, align 8
  %arrayidx2 = getelementptr inbounds [64 x i64]* @nonempty_masks, i32 0, i64 %6
  store i64 %neg, i64* %arrayidx2, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %7 = load i64* %i, align 8
  %inc = add nsw i64 %7, 1
  store i64 %inc, i64* %i, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal %struct.grid* @init_world_grid(%struct.voxel* %v, %struct.element** %pepa, i64 %num_pe) {
entry:
  %v.addr = alloca %struct.voxel*, align 8
  %pepa.addr = alloca %struct.element**, align 8
  %num_pe.addr = alloca i64, align 8
  %ec = alloca i64*, align 8
  %pc = alloca i64*, align 8
  %wbox = alloca %struct.bbox, align 8
  %g = alloca %struct.grid*, align 8
  %ht = alloca %struct.voxel**, align 8
  store %struct.voxel* %v, %struct.voxel** %v.addr, align 8
  store %struct.element** %pepa, %struct.element*** %pepa.addr, align 8
  store i64 %num_pe, i64* %num_pe.addr, align 8
  %call = call i8* @ObjectMalloc(i64 0, i64 1)
  %0 = bitcast i8* %call to %struct.grid*
  store %struct.grid* %0, %struct.grid** %g, align 8
  %1 = load i64* @grids, align 8
  %inc = add nsw i64 %1, 1
  store i64 %inc, i64* @grids, align 8
  %2 = load %struct.grid** %g, align 8
  %id = getelementptr inbounds %struct.grid* %2, i32 0, i32 0
  store i64 %1, i64* %id, align 8
  %call1 = call i8* @ObjectMalloc(i64 2, i64 1)
  %3 = bitcast i8* %call1 to %struct.voxel**
  store %struct.voxel** %3, %struct.voxel*** %ht, align 8
  %4 = load %struct.voxel*** %ht, align 8
  %5 = load %struct.grid** %g, align 8
  %hashtable = getelementptr inbounds %struct.grid* %5, i32 0, i32 1
  store %struct.voxel** %4, %struct.voxel*** %hashtable, align 8
  %6 = load %struct.voxel** %v.addr, align 8
  %7 = load %struct.grid** %g, align 8
  %hashtable2 = getelementptr inbounds %struct.grid* %7, i32 0, i32 1
  %8 = load %struct.voxel*** %hashtable2, align 8
  %arrayidx = getelementptr inbounds %struct.voxel** %8, i64 0
  store %struct.voxel* %6, %struct.voxel** %arrayidx, align 8
  %call3 = call i8* @ObjectMalloc(i64 3, i64 1)
  %9 = bitcast i8* %call3 to i64*
  store i64* %9, i64** %ec, align 8
  %10 = load i64** %ec, align 8
  %11 = load %struct.grid** %g, align 8
  %emptycells = getelementptr inbounds %struct.grid* %11, i32 0, i32 2
  store i64* %10, i64** %emptycells, align 8
  %12 = load %struct.grid** %g, align 8
  %emptycells4 = getelementptr inbounds %struct.grid* %12, i32 0, i32 2
  %13 = load i64** %emptycells4, align 8
  %arrayidx5 = getelementptr inbounds i64* %13, i64 0
  store i64 0, i64* %arrayidx5, align 8
  %14 = load %struct.grid** %g, align 8
  %indx_inc = getelementptr inbounds %struct.grid* %14, i32 0, i32 5
  %arrayidx6 = getelementptr inbounds [3 x i64]* %indx_inc, i32 0, i64 0
  store i64 1, i64* %arrayidx6, align 8
  %15 = load %struct.grid** %g, align 8
  %indx_inc7 = getelementptr inbounds %struct.grid* %15, i32 0, i32 5
  %arrayidx8 = getelementptr inbounds [3 x i64]* %indx_inc7, i32 0, i64 1
  store i64 1, i64* %arrayidx8, align 8
  %16 = load %struct.grid** %g, align 8
  %indx_inc9 = getelementptr inbounds %struct.grid* %16, i32 0, i32 5
  %arrayidx10 = getelementptr inbounds [3 x i64]* %indx_inc9, i32 0, i64 2
  store i64 1, i64* %arrayidx10, align 8
  %17 = load %struct.grid** %g, align 8
  %num_buckets = getelementptr inbounds %struct.grid* %17, i32 0, i32 6
  store i64 1, i64* %num_buckets, align 8
  %dnear = getelementptr inbounds %struct.bbox* %wbox, i32 0, i32 0
  %arrayidx11 = getelementptr inbounds [3 x double]* %dnear, i32 0, i64 0
  store double 0.000000e+00, double* %arrayidx11, align 8
  %dnear14 = getelementptr inbounds %struct.bbox* %wbox, i32 0, i32 0
  %arrayidx15 = getelementptr inbounds [3 x double]* %dnear14, i32 0, i64 2
  store double 0.000000e+00, double* %arrayidx15, align 8
  %dfar = getelementptr inbounds %struct.bbox* %wbox, i32 0, i32 1
  %arrayidx16 = getelementptr inbounds [3 x double]* %dfar, i32 0, i64 0
  store double 1.000000e+00, double* %arrayidx16, align 8
  %dfar19 = getelementptr inbounds %struct.bbox* %wbox, i32 0, i32 1
  %arrayidx20 = getelementptr inbounds [3 x double]* %dfar19, i32 0, i64 2
  store double 1.000000e+00, double* %arrayidx20, align 8
  %dfar32 = getelementptr inbounds %struct.bbox* %wbox, i32 0, i32 1
  %arrayidx33 = getelementptr inbounds [3 x double]* %dfar32, i32 0, i64 0
  %18 = load double* %arrayidx33, align 8
  %dnear34 = getelementptr inbounds %struct.bbox* %wbox, i32 0, i32 0
  %arrayidx35 = getelementptr inbounds [3 x double]* %dnear34, i32 0, i64 0
  %19 = load double* %arrayidx35, align 8
  %sub = fsub double %18, %19
  %20 = load %struct.grid** %g, align 8
  %cellsize = getelementptr inbounds %struct.grid* %20, i32 0, i32 8
  %arrayidx36 = getelementptr inbounds [3 x double]* %cellsize, i32 0, i64 0
  store double %sub, double* %arrayidx36, align 8
  %dfar44 = getelementptr inbounds %struct.bbox* %wbox, i32 0, i32 1
  %arrayidx45 = getelementptr inbounds [3 x double]* %dfar44, i32 0, i64 2
  %21 = load double* %arrayidx45, align 8
  %dnear46 = getelementptr inbounds %struct.bbox* %wbox, i32 0, i32 0
  %arrayidx47 = getelementptr inbounds [3 x double]* %dnear46, i32 0, i64 2
  %22 = load double* %arrayidx47, align 8
  %sub48 = fsub double %21, %22
  %23 = load %struct.grid** %g, align 8
  %cellsize49 = getelementptr inbounds %struct.grid* %23, i32 0, i32 8
  %arrayidx50 = getelementptr inbounds [3 x double]* %cellsize49, i32 0, i64 2
  store double %sub48, double* %arrayidx50, align 8
  %24 = load %struct.grid** %g, align 8
  %subdiv_level = getelementptr inbounds %struct.grid* %24, i32 0, i32 9
  store i64 -1, i64* %subdiv_level, align 8
  %25 = load i64* %num_pe.addr, align 8
  %26 = load %struct.grid** %g, align 8
  %num_prims = getelementptr inbounds %struct.grid* %26, i32 0, i32 4
  store i64 %25, i64* %num_prims, align 8
  %27 = load %struct.element*** %pepa.addr, align 8
  %28 = load %struct.grid** %g, align 8
  %pepa51 = getelementptr inbounds %struct.grid* %28, i32 0, i32 3
  store %struct.element** %27, %struct.element*** %pepa51, align 8
  %29 = load %struct.grid** %g, align 8
  %next = getelementptr inbounds %struct.grid* %29, i32 0, i32 11
  store %struct.grid* null, %struct.grid** %next, align 8
  %30 = load %struct.grid** %g, align 8
  store %struct.grid* %30, %struct.grid** @gridlist, align 8
  %31 = load %struct.grid** %g, align 8
  ret %struct.grid* %31
}

; Function Attrs: nounwind uwtable
define internal %struct.voxel* @init_world_voxel(%struct.element** %pepa, i64 %numelements) {
entry:
  %pepa.addr = alloca %struct.element**, align 8
  %numelements.addr = alloca i64, align 8
  %v = alloca %struct.voxel*, align 8
  store %struct.element** %pepa, %struct.element*** %pepa.addr, align 8
  store i64 %numelements, i64* %numelements.addr, align 8
  %call = call i8* @ObjectMalloc(i64 1, i64 1)
  %0 = bitcast i8* %call to %struct.voxel*
  store %struct.voxel* %0, %struct.voxel** %v, align 8
  %1 = load %struct.voxel** %v, align 8
  %id = getelementptr inbounds %struct.voxel* %1, i32 0, i32 0
  store i64 0, i64* %id, align 8
  %2 = load %struct.element*** %pepa.addr, align 8
  %3 = bitcast %struct.element** %2 to i8*
  %4 = load %struct.voxel** %v, align 8
  %cell = getelementptr inbounds %struct.voxel* %4, i32 0, i32 1
  store i8* %3, i8** %cell, align 8
  %5 = load i64* %numelements.addr, align 8
  %6 = load %struct.voxel** %v, align 8
  %numelements1 = getelementptr inbounds %struct.voxel* %6, i32 0, i32 3
  store i64 %5, i64* %numelements1, align 8
  %7 = load %struct.voxel** %v, align 8
  %celltype = getelementptr inbounds %struct.voxel* %7, i32 0, i32 2
  store i8 2, i8* %celltype, align 1
  %8 = load %struct.voxel** %v, align 8
  %next = getelementptr inbounds %struct.voxel* %8, i32 0, i32 4
  store %struct.voxel* null, %struct.voxel** %next, align 8
  %9 = load %struct.voxel** %v, align 8
  ret %struct.voxel* %9
}

; Function Attrs: nounwind uwtable
define internal void @mark_empty(i64 %index1D, %struct.grid* %g) {
entry:
  %index1D.addr = alloca i64, align 8
  %g.addr = alloca %struct.grid*, align 8
  %i = alloca i64, align 8
  %r = alloca i64, align 8
  %w = alloca i64, align 8
  store i64 %index1D, i64* %index1D.addr, align 8
  store %struct.grid* %g, %struct.grid** %g.addr, align 8
  %0 = load i64* %index1D.addr, align 8
  %div = udiv i64 %0, 64
  store i64 %div, i64* %i, align 8
  %1 = load i64* %index1D.addr, align 8
  %2 = load i64* %i, align 8
  %mul = mul i64 %2, 8
  %mul1 = mul i64 %mul, 8
  %sub = sub i64 %1, %mul1
  store i64 %sub, i64* %r, align 8
  %3 = load i64* %i, align 8
  %4 = load %struct.grid** %g.addr, align 8
  %emptycells = getelementptr inbounds %struct.grid* %4, i32 0, i32 2
  %5 = load i64** %emptycells, align 8
  %arrayidx = getelementptr inbounds i64* %5, i64 %3
  %6 = load i64* %arrayidx, align 8
  store i64 %6, i64* %w, align 8
  %7 = load i64* %w, align 8
  %8 = load i64* %r, align 8
  %arrayidx2 = getelementptr inbounds [64 x i64]* @empty_masks, i32 0, i64 %8
  %9 = load i64* %arrayidx2, align 8
  %or = or i64 %7, %9
  store i64 %or, i64* %w, align 8
  %10 = load i64* %w, align 8
  %11 = load i64* %i, align 8
  %12 = load %struct.grid** %g.addr, align 8
  %emptycells3 = getelementptr inbounds %struct.grid* %12, i32 0, i32 2
  %13 = load i64** %emptycells3, align 8
  %arrayidx4 = getelementptr inbounds i64* %13, i64 %11
  store i64 %10, i64* %arrayidx4, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @mark_nonempty(i64 %index1D, %struct.grid* %g) {
entry:
  %index1D.addr = alloca i64, align 8
  %g.addr = alloca %struct.grid*, align 8
  %i = alloca i64, align 8
  %r = alloca i64, align 8
  %w = alloca i64, align 8
  store i64 %index1D, i64* %index1D.addr, align 8
  store %struct.grid* %g, %struct.grid** %g.addr, align 8
  %0 = load i64* %index1D.addr, align 8
  %div = udiv i64 %0, 64
  store i64 %div, i64* %i, align 8
  %1 = load i64* %index1D.addr, align 8
  %2 = load i64* %i, align 8
  %mul = mul i64 %2, 8
  %mul1 = mul i64 %mul, 8
  %sub = sub i64 %1, %mul1
  store i64 %sub, i64* %r, align 8
  %3 = load i64* %i, align 8
  %4 = load %struct.grid** %g.addr, align 8
  %emptycells = getelementptr inbounds %struct.grid* %4, i32 0, i32 2
  %5 = load i64** %emptycells, align 8
  %arrayidx = getelementptr inbounds i64* %5, i64 %3
  %6 = load i64* %arrayidx, align 8
  store i64 %6, i64* %w, align 8
  %7 = load i64* %w, align 8
  %8 = load i64* %r, align 8
  %arrayidx2 = getelementptr inbounds [64 x i64]* @nonempty_masks, i32 0, i64 %8
  %9 = load i64* %arrayidx2, align 8
  %and = and i64 %7, %9
  store i64 %and, i64* %w, align 8
  %10 = load i64* %w, align 8
  %11 = load i64* %i, align 8
  %12 = load %struct.grid** %g.addr, align 8
  %emptycells3 = getelementptr inbounds %struct.grid* %12, i32 0, i32 2
  %13 = load i64** %emptycells3, align 8
  %arrayidx4 = getelementptr inbounds i64* %13, i64 %11
  store i64 %10, i64* %arrayidx4, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @insert_in_hashtable(%struct.voxel* %v, %struct.grid* %g) {
entry:
  %v.addr = alloca %struct.voxel*, align 8
  %g.addr = alloca %struct.grid*, align 8
  %i = alloca i64, align 8
  %r = alloca i64, align 8
  %vht = alloca %struct.voxel*, align 8
  store %struct.voxel* %v, %struct.voxel** %v.addr, align 8
  store %struct.grid* %g, %struct.grid** %g.addr, align 8
  %0 = load %struct.voxel** %v.addr, align 8
  %id = getelementptr inbounds %struct.voxel* %0, i32 0, i32 0
  %1 = load i64* %id, align 8
  %2 = load i64* @hu_numbuckets, align 8
  %div = sdiv i64 %1, %2
  store i64 %div, i64* %i, align 8
  %3 = load %struct.voxel** %v.addr, align 8
  %id1 = getelementptr inbounds %struct.voxel* %3, i32 0, i32 0
  %4 = load i64* %id1, align 8
  %5 = load i64* %i, align 8
  %6 = load i64* @hu_numbuckets, align 8
  %mul = mul nsw i64 %5, %6
  %sub = sub nsw i64 %4, %mul
  store i64 %sub, i64* %r, align 8
  %7 = load i64* %r, align 8
  %8 = load %struct.grid** %g.addr, align 8
  %hashtable = getelementptr inbounds %struct.grid* %8, i32 0, i32 1
  %9 = load %struct.voxel*** %hashtable, align 8
  %arrayidx = getelementptr inbounds %struct.voxel** %9, i64 %7
  %10 = load %struct.voxel** %arrayidx, align 8
  store %struct.voxel* %10, %struct.voxel** %vht, align 8
  %11 = load %struct.voxel** %vht, align 8
  %12 = load %struct.voxel** %v.addr, align 8
  %next = getelementptr inbounds %struct.voxel* %12, i32 0, i32 4
  store %struct.voxel* %11, %struct.voxel** %next, align 8
  %13 = load %struct.voxel** %v.addr, align 8
  %14 = load i64* %r, align 8
  %15 = load %struct.grid** %g.addr, align 8
  %hashtable2 = getelementptr inbounds %struct.grid* %15, i32 0, i32 1
  %16 = load %struct.voxel*** %hashtable2, align 8
  %arrayidx3 = getelementptr inbounds %struct.voxel** %16, i64 %14
  store %struct.voxel* %13, %struct.voxel** %arrayidx3, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal %struct.element** @prims_in_box2(%struct.element** %pepa, i64 %n_in, %struct.bbox* byval align 8 %b, i64* %n) {
entry:
  %retval = alloca %struct.element**, align 8
  %pepa.addr = alloca %struct.element**, align 8
  %n_in.addr = alloca i64, align 8
  %n.addr = alloca i64*, align 8
  %ovlap = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %k = alloca i64, align 8
  %pe = alloca %struct.element*, align 8
  %npepa = alloca %struct.element**, align 8
  %bb = alloca %struct.bbox, align 8
  %max = alloca double, align 8
  %side = alloca double, align 8
  %eps = alloca double, align 8
  store %struct.element** %pepa, %struct.element*** %pepa.addr, align 8
  store i64 %n_in, i64* %n_in.addr, align 8
  store i64* %n, i64** %n.addr, align 8
  %dfar = getelementptr inbounds %struct.bbox* %b, i32 0, i32 1
  %arrayidx = getelementptr inbounds [3 x double]* %dfar, i32 0, i64 0
  %0 = load double* %arrayidx, align 8
  %dnear = getelementptr inbounds %struct.bbox* %b, i32 0, i32 0
  %arrayidx1 = getelementptr inbounds [3 x double]* %dnear, i32 0, i64 0
  %1 = load double* %arrayidx1, align 8
  %sub = fsub double %0, %1
  store double %sub, double* %max, align 8
  %dfar2 = getelementptr inbounds %struct.bbox* %b, i32 0, i32 1
  %arrayidx3 = getelementptr inbounds [3 x double]* %dfar2, i32 0, i64 1
  %2 = load double* %arrayidx3, align 8
  %dnear4 = getelementptr inbounds %struct.bbox* %b, i32 0, i32 0
  %arrayidx5 = getelementptr inbounds [3 x double]* %dnear4, i32 0, i64 1
  %3 = load double* %arrayidx5, align 8
  %sub6 = fsub double %2, %3
  store double %sub6, double* %side, align 8
  %4 = load double* %max, align 8
  %5 = load double* %side, align 8
  %cmp = fcmp ogt double %4, %5
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  %6 = load double* %max, align 8
  br label %cond.end

cond.false:                                       ; preds = %entry
  %7 = load double* %side, align 8
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi double [ %6, %cond.true ], [ %7, %cond.false ]
  store double %cond, double* %max, align 8
  %dfar7 = getelementptr inbounds %struct.bbox* %b, i32 0, i32 1
  %arrayidx8 = getelementptr inbounds [3 x double]* %dfar7, i32 0, i64 2
  %8 = load double* %arrayidx8, align 8
  %dnear9 = getelementptr inbounds %struct.bbox* %b, i32 0, i32 0
  %arrayidx10 = getelementptr inbounds [3 x double]* %dnear9, i32 0, i64 2
  %9 = load double* %arrayidx10, align 8
  %sub11 = fsub double %8, %9
  store double %sub11, double* %side, align 8
  %10 = load double* %max, align 8
  %11 = load double* %side, align 8
  %cmp12 = fcmp ogt double %10, %11
  br i1 %cmp12, label %cond.true.13, label %cond.false.14

cond.true.13:                                     ; preds = %cond.end
  %12 = load double* %max, align 8
  br label %cond.end.15

cond.false.14:                                    ; preds = %cond.end
  %13 = load double* %side, align 8
  br label %cond.end.15

cond.end.15:                                      ; preds = %cond.false.14, %cond.true.13
  %cond16 = phi double [ %12, %cond.true.13 ], [ %13, %cond.false.14 ]
  store double %cond16, double* %max, align 8
  %14 = load double* %max, align 8
  %mul = fmul double %14, 1.000000e-06
  store double %mul, double* %eps, align 8
  %15 = load i64* %n_in.addr, align 8
  %cmp17 = icmp sgt i64 %15, 0
  br i1 %cmp17, label %if.then, label %if.else

if.then:                                          ; preds = %cond.end.15
  %16 = load i64* %n_in.addr, align 8
  %call = call i8* @ObjectMalloc(i64 7, i64 %16)
  %17 = bitcast i8* %call to %struct.element**
  store %struct.element** %17, %struct.element*** %npepa, align 8
  br label %if.end

if.else:                                          ; preds = %cond.end.15
  %18 = load i64** %n.addr, align 8
  store i64 0, i64* %18, align 8
  %19 = load %struct.element*** %npepa, align 8
  store %struct.element** %19, %struct.element*** %retval
  br label %return

if.end:                                           ; preds = %if.then
  %20 = load i64** %n.addr, align 8
  store i64 0, i64* %20, align 8
  store i64 0, i64* %k, align 8
  store i64 0, i64* %j, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc.87, %if.end
  %21 = load i64* %j, align 8
  %22 = load i64* %n_in.addr, align 8
  %cmp19 = icmp slt i64 %21, %22
  br i1 %cmp19, label %for.body, label %for.end.89

for.body:                                         ; preds = %for.cond
  %23 = load i64* %j, align 8
  %24 = load %struct.element*** %pepa.addr, align 8
  %arrayidx21 = getelementptr inbounds %struct.element** %24, i64 %23
  %25 = load %struct.element** %arrayidx21, align 8
  store %struct.element* %25, %struct.element** %pe, align 8
  %26 = load %struct.element** %pe, align 8
  %bv = getelementptr inbounds %struct.element* %26, i32 0, i32 1
  %27 = bitcast %struct.bbox* %bb to i8*
  %28 = bitcast %struct.bbox* %bv to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %27, i8* %28, i64 48, i32 8, i1 false)
  store i64 1, i64* %ovlap, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond.22

for.cond.22:                                      ; preds = %for.inc, %for.body
  %29 = load i64* %i, align 8
  %cmp23 = icmp slt i64 %29, 1
  br i1 %cmp23, label %for.body.25, label %for.end

for.body.25:                                      ; preds = %for.cond.22
  %dnear26 = getelementptr inbounds %struct.bbox* %b, i32 0, i32 0
  %arrayidx27 = getelementptr inbounds [3 x double]* %dnear26, i32 0, i64 0
  %30 = load double* %arrayidx27, align 8
  %dfar28 = getelementptr inbounds %struct.bbox* %bb, i32 0, i32 1
  %arrayidx29 = getelementptr inbounds [3 x double]* %dfar28, i32 0, i64 0
  %31 = load double* %arrayidx29, align 8
  %32 = load double* %eps, align 8
  %add = fadd double %31, %32
  %cmp30 = fcmp ogt double %30, %add
  br i1 %cmp30, label %if.then.32, label %if.end.33

if.then.32:                                       ; preds = %for.body.25
  store i64 0, i64* %ovlap, align 8
  br label %for.end

if.end.33:                                        ; preds = %for.body.25
  %dnear34 = getelementptr inbounds %struct.bbox* %b, i32 0, i32 0
  %arrayidx35 = getelementptr inbounds [3 x double]* %dnear34, i32 0, i64 1
  %33 = load double* %arrayidx35, align 8
  %dfar36 = getelementptr inbounds %struct.bbox* %bb, i32 0, i32 1
  %arrayidx37 = getelementptr inbounds [3 x double]* %dfar36, i32 0, i64 1
  %34 = load double* %arrayidx37, align 8
  %35 = load double* %eps, align 8
  %add38 = fadd double %34, %35
  %cmp39 = fcmp ogt double %33, %add38
  br i1 %cmp39, label %if.then.41, label %if.end.42

if.then.41:                                       ; preds = %if.end.33
  store i64 0, i64* %ovlap, align 8
  br label %for.end

if.end.42:                                        ; preds = %if.end.33
  %dnear43 = getelementptr inbounds %struct.bbox* %b, i32 0, i32 0
  %arrayidx44 = getelementptr inbounds [3 x double]* %dnear43, i32 0, i64 2
  %36 = load double* %arrayidx44, align 8
  %dfar45 = getelementptr inbounds %struct.bbox* %bb, i32 0, i32 1
  %arrayidx46 = getelementptr inbounds [3 x double]* %dfar45, i32 0, i64 2
  %37 = load double* %arrayidx46, align 8
  %38 = load double* %eps, align 8
  %add47 = fadd double %37, %38
  %cmp48 = fcmp ogt double %36, %add47
  br i1 %cmp48, label %if.then.50, label %if.end.51

if.then.50:                                       ; preds = %if.end.42
  store i64 0, i64* %ovlap, align 8
  br label %for.end

if.end.51:                                        ; preds = %if.end.42
  %dfar52 = getelementptr inbounds %struct.bbox* %b, i32 0, i32 1
  %arrayidx53 = getelementptr inbounds [3 x double]* %dfar52, i32 0, i64 0
  %39 = load double* %arrayidx53, align 8
  %dnear54 = getelementptr inbounds %struct.bbox* %bb, i32 0, i32 0
  %arrayidx55 = getelementptr inbounds [3 x double]* %dnear54, i32 0, i64 0
  %40 = load double* %arrayidx55, align 8
  %41 = load double* %eps, align 8
  %sub56 = fsub double %40, %41
  %cmp57 = fcmp olt double %39, %sub56
  br i1 %cmp57, label %if.then.59, label %if.end.60

if.then.59:                                       ; preds = %if.end.51
  store i64 0, i64* %ovlap, align 8
  br label %for.end

if.end.60:                                        ; preds = %if.end.51
  %dfar61 = getelementptr inbounds %struct.bbox* %b, i32 0, i32 1
  %arrayidx62 = getelementptr inbounds [3 x double]* %dfar61, i32 0, i64 1
  %42 = load double* %arrayidx62, align 8
  %dnear63 = getelementptr inbounds %struct.bbox* %bb, i32 0, i32 0
  %arrayidx64 = getelementptr inbounds [3 x double]* %dnear63, i32 0, i64 1
  %43 = load double* %arrayidx64, align 8
  %44 = load double* %eps, align 8
  %sub65 = fsub double %43, %44
  %cmp66 = fcmp olt double %42, %sub65
  br i1 %cmp66, label %if.then.68, label %if.end.69

if.then.68:                                       ; preds = %if.end.60
  store i64 0, i64* %ovlap, align 8
  br label %for.end

if.end.69:                                        ; preds = %if.end.60
  %dfar70 = getelementptr inbounds %struct.bbox* %b, i32 0, i32 1
  %arrayidx71 = getelementptr inbounds [3 x double]* %dfar70, i32 0, i64 2
  %45 = load double* %arrayidx71, align 8
  %dnear72 = getelementptr inbounds %struct.bbox* %bb, i32 0, i32 0
  %arrayidx73 = getelementptr inbounds [3 x double]* %dnear72, i32 0, i64 2
  %46 = load double* %arrayidx73, align 8
  %47 = load double* %eps, align 8
  %sub74 = fsub double %46, %47
  %cmp75 = fcmp olt double %45, %sub74
  br i1 %cmp75, label %if.then.77, label %if.end.78

if.then.77:                                       ; preds = %if.end.69
  store i64 0, i64* %ovlap, align 8
  br label %for.end

if.end.78:                                        ; preds = %if.end.69
  br label %for.inc

for.inc:                                          ; preds = %if.end.78
  %48 = load i64* %i, align 8
  %inc = add nsw i64 %48, 1
  store i64 %inc, i64* %i, align 8
  br label %for.cond.22

for.end:                                          ; preds = %if.then.77, %if.then.68, %if.then.59, %if.then.50, %if.then.41, %if.then.32, %for.cond.22
  %49 = load i64* %ovlap, align 8
  %cmp79 = icmp eq i64 %49, 1
  br i1 %cmp79, label %if.then.81, label %if.end.86

if.then.81:                                       ; preds = %for.end
  %50 = load i64* %j, align 8
  %51 = load %struct.element*** %pepa.addr, align 8
  %arrayidx82 = getelementptr inbounds %struct.element** %51, i64 %50
  %52 = load %struct.element** %arrayidx82, align 8
  %53 = load i64* %k, align 8
  %inc83 = add nsw i64 %53, 1
  store i64 %inc83, i64* %k, align 8
  %54 = load %struct.element*** %npepa, align 8
  %arrayidx84 = getelementptr inbounds %struct.element** %54, i64 %53
  store %struct.element* %52, %struct.element** %arrayidx84, align 8
  %55 = load i64** %n.addr, align 8
  %56 = load i64* %55, align 8
  %inc85 = add nsw i64 %56, 1
  store i64 %inc85, i64* %55, align 8
  br label %if.end.86

if.end.86:                                        ; preds = %if.then.81, %for.end
  br label %for.inc.87

for.inc.87:                                       ; preds = %if.end.86
  %57 = load i64* %j, align 8
  %inc88 = add nsw i64 %57, 1
  store i64 %inc88, i64* %j, align 8
  br label %for.cond

for.end.89:                                       ; preds = %for.cond
  %58 = load %struct.element*** %npepa, align 8
  store %struct.element** %58, %struct.element*** %retval
  br label %return

return:                                           ; preds = %for.end.89, %if.else
  %59 = load %struct.element*** %retval
  ret %struct.element** %59
}

; Function Attrs: nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture , i64, i32, i1)

; Function Attrs: nounwind uwtable
define internal %struct.btnode* @init_bintree(%struct.grid* %ng) {
entry:
  %ng.addr = alloca %struct.grid*, align 8
  %btn = alloca %struct.btnode*, align 8
  %pepa = alloca %struct.element**, align 8
  store %struct.grid* %ng, %struct.grid** %ng.addr, align 8
  %call = call i8* @ObjectMalloc(i64 6, i64 1)
  %0 = bitcast i8* %call to %struct.btnode*
  store %struct.btnode* %0, %struct.btnode** %btn, align 8
  %1 = load %struct.btnode** %btn, align 8
  %btn1 = getelementptr inbounds %struct.btnode* %1, i32 0, i32 7
  %arrayidx = getelementptr inbounds [2 x %struct.btnode*]* %btn1, i32 0, i64 0
  store %struct.btnode* null, %struct.btnode** %arrayidx, align 8
  %2 = load %struct.btnode** %btn, align 8
  %btn2 = getelementptr inbounds %struct.btnode* %2, i32 0, i32 7
  %arrayidx3 = getelementptr inbounds [2 x %struct.btnode*]* %btn2, i32 0, i64 1
  store %struct.btnode* null, %struct.btnode** %arrayidx3, align 8
  %3 = load %struct.btnode** %btn, align 8
  %axis = getelementptr inbounds %struct.btnode* %3, i32 0, i32 5
  store i64 -1, i64* %axis, align 8
  %4 = load %struct.grid** %ng.addr, align 8
  %min = getelementptr inbounds %struct.grid* %4, i32 0, i32 7
  %arrayidx4 = getelementptr inbounds [3 x double]* %min, i32 0, i64 0
  %5 = load double* %arrayidx4, align 8
  %6 = load %struct.btnode** %btn, align 8
  %p = getelementptr inbounds %struct.btnode* %6, i32 0, i32 1
  %arrayidx5 = getelementptr inbounds [3 x double]* %p, i32 0, i64 0
  store double %5, double* %arrayidx5, align 8
  %7 = load %struct.grid** %ng.addr, align 8
  %min6 = getelementptr inbounds %struct.grid* %7, i32 0, i32 7
  %arrayidx7 = getelementptr inbounds [3 x double]* %min6, i32 0, i64 1
  %8 = load double* %arrayidx7, align 8
  %9 = load %struct.btnode** %btn, align 8
  %p8 = getelementptr inbounds %struct.btnode* %9, i32 0, i32 1
  %arrayidx9 = getelementptr inbounds [3 x double]* %p8, i32 0, i64 1
  store double %8, double* %arrayidx9, align 8
  %10 = load %struct.grid** %ng.addr, align 8
  %min10 = getelementptr inbounds %struct.grid* %10, i32 0, i32 7
  %arrayidx11 = getelementptr inbounds [3 x double]* %min10, i32 0, i64 2
  %11 = load double* %arrayidx11, align 8
  %12 = load %struct.btnode** %btn, align 8
  %p12 = getelementptr inbounds %struct.btnode* %12, i32 0, i32 1
  %arrayidx13 = getelementptr inbounds [3 x double]* %p12, i32 0, i64 2
  store double %11, double* %arrayidx13, align 8
  %13 = load %struct.grid** %ng.addr, align 8
  %indx_inc = getelementptr inbounds %struct.grid* %13, i32 0, i32 5
  %arrayidx14 = getelementptr inbounds [3 x i64]* %indx_inc, i32 0, i64 1
  %14 = load i64* %arrayidx14, align 8
  %15 = load %struct.btnode** %btn, align 8
  %n = getelementptr inbounds %struct.btnode* %15, i32 0, i32 3
  %arrayidx15 = getelementptr inbounds [3 x i64]* %n, i32 0, i64 0
  store i64 %14, i64* %arrayidx15, align 8
  %16 = load %struct.grid** %ng.addr, align 8
  %indx_inc16 = getelementptr inbounds %struct.grid* %16, i32 0, i32 5
  %arrayidx17 = getelementptr inbounds [3 x i64]* %indx_inc16, i32 0, i64 1
  %17 = load i64* %arrayidx17, align 8
  %18 = load %struct.btnode** %btn, align 8
  %n18 = getelementptr inbounds %struct.btnode* %18, i32 0, i32 3
  %arrayidx19 = getelementptr inbounds [3 x i64]* %n18, i32 0, i64 1
  store i64 %17, i64* %arrayidx19, align 8
  %19 = load %struct.grid** %ng.addr, align 8
  %indx_inc20 = getelementptr inbounds %struct.grid* %19, i32 0, i32 5
  %arrayidx21 = getelementptr inbounds [3 x i64]* %indx_inc20, i32 0, i64 1
  %20 = load i64* %arrayidx21, align 8
  %21 = load %struct.btnode** %btn, align 8
  %n22 = getelementptr inbounds %struct.btnode* %21, i32 0, i32 3
  %arrayidx23 = getelementptr inbounds [3 x i64]* %n22, i32 0, i64 2
  store i64 %20, i64* %arrayidx23, align 8
  %22 = load %struct.btnode** %btn, align 8
  %i = getelementptr inbounds %struct.btnode* %22, i32 0, i32 4
  %arrayidx24 = getelementptr inbounds [3 x i64]* %i, i32 0, i64 0
  store i64 0, i64* %arrayidx24, align 8
  %23 = load %struct.grid** %ng.addr, align 8
  %num_prims = getelementptr inbounds %struct.grid* %23, i32 0, i32 4
  %24 = load i64* %num_prims, align 8
  %25 = load %struct.btnode** %btn, align 8
  %nprims = getelementptr inbounds %struct.btnode* %25, i32 0, i32 2
  store i64 %24, i64* %nprims, align 8
  %26 = load %struct.btnode** %btn, align 8
  %nprims29 = getelementptr inbounds %struct.btnode* %26, i32 0, i32 2
  %27 = load i64* %nprims29, align 8
  %28 = load %struct.btnode** %btn, align 8
  %totalPrimsAllocated = getelementptr inbounds %struct.btnode* %28, i32 0, i32 6
  store i64 %27, i64* %totalPrimsAllocated, align 8
  %29 = load %struct.grid** %ng.addr, align 8
  %num_prims30 = getelementptr inbounds %struct.grid* %29, i32 0, i32 4
  %30 = load i64* %num_prims30, align 8
  %cmp = icmp sgt i64 %30, 0
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %31 = load %struct.grid** %ng.addr, align 8
  %pepa31 = getelementptr inbounds %struct.grid* %31, i32 0, i32 3
  %32 = load %struct.element*** %pepa31, align 8
  %33 = load %struct.btnode** %btn, align 8
  %pe = getelementptr inbounds %struct.btnode* %33, i32 0, i32 0
  store %struct.element** %32, %struct.element*** %pe, align 8
  br label %if.end

if.else:                                          ; preds = %entry
  %34 = load %struct.btnode** %btn, align 8
  %pe32 = getelementptr inbounds %struct.btnode* %34, i32 0, i32 0
  store %struct.element** null, %struct.element*** %pe32, align 8
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %35 = load %struct.btnode** %btn, align 8
  ret %struct.btnode* %35
}

; Function Attrs: nounwind uwtable
define internal void @subdiv_bintree(%struct.btnode* %btn, %struct.grid* %g) {
entry:
  %btn.addr = alloca %struct.btnode*, align 8
  %g.addr = alloca %struct.grid*, align 8
  %btn1 = alloca %struct.btnode*, align 8
  %btn2 = alloca %struct.btnode*, align 8
  %n1 = alloca i64, align 8
  %n2 = alloca i64, align 8
  %imax = alloca i64, align 8
  %dmax = alloca i64, align 8
  %b1 = alloca %struct.bbox, align 8
  %b2 = alloca %struct.bbox, align 8
  store %struct.btnode* %btn, %struct.btnode** %btn.addr, align 8
  store %struct.grid* %g, %struct.grid** %g.addr, align 8
  store i64 0, i64* %imax, align 8
  %0 = load %struct.btnode** %btn.addr, align 8
  %n = getelementptr inbounds %struct.btnode* %0, i32 0, i32 3
  %arrayidx = getelementptr inbounds [3 x i64]* %n, i32 0, i64 0
  %1 = load i64* %arrayidx, align 8
  store i64 %1, i64* %dmax, align 8
  %2 = load i64* %dmax, align 8
  %3 = load %struct.btnode** %btn.addr, align 8
  %n3 = getelementptr inbounds %struct.btnode* %3, i32 0, i32 3
  %arrayidx4 = getelementptr inbounds [3 x i64]* %n3, i32 0, i64 1
  %4 = load i64* %arrayidx4, align 8
  %cmp = icmp slt i64 %2, %4
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i64 1, i64* %imax, align 8
  %5 = load %struct.btnode** %btn.addr, align 8
  %n5 = getelementptr inbounds %struct.btnode* %5, i32 0, i32 3
  %arrayidx6 = getelementptr inbounds [3 x i64]* %n5, i32 0, i64 1
  %6 = load i64* %arrayidx6, align 8
  store i64 %6, i64* %dmax, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %7 = load i64* %dmax, align 8
  %8 = load %struct.btnode** %btn.addr, align 8
  %n7 = getelementptr inbounds %struct.btnode* %8, i32 0, i32 3
  %arrayidx8 = getelementptr inbounds [3 x i64]* %n7, i32 0, i64 2
  %9 = load i64* %arrayidx8, align 8
  %cmp9 = icmp slt i64 %7, %9
  br i1 %cmp9, label %if.then.10, label %if.end.13

if.then.10:                                       ; preds = %if.end
  store i64 2, i64* %imax, align 8
  br label %if.end.13

if.end.13:                                        ; preds = %if.then.10, %if.end
  %10 = load i64* %imax, align 8
  %11 = load %struct.btnode** %btn.addr, align 8
  %axis = getelementptr inbounds %struct.btnode* %11, i32 0, i32 5
  store i64 %10, i64* %axis, align 8
  %12 = load %struct.btnode** %btn.addr, align 8
  %btn14 = getelementptr inbounds %struct.btnode* %12, i32 0, i32 7
  %arrayidx15 = getelementptr inbounds [2 x %struct.btnode*]* %btn14, i32 0, i64 0
  store %struct.btnode* null, %struct.btnode** %arrayidx15, align 8
  %13 = load %struct.btnode** %btn.addr, align 8
  %btn16 = getelementptr inbounds %struct.btnode* %13, i32 0, i32 7
  %arrayidx17 = getelementptr inbounds [2 x %struct.btnode*]* %btn16, i32 0, i64 1
  store %struct.btnode* null, %struct.btnode** %arrayidx17, align 8
  %14 = load i64* %imax, align 8
  %15 = load %struct.btnode** %btn.addr, align 8
  %n18 = getelementptr inbounds %struct.btnode* %15, i32 0, i32 3
  %arrayidx19 = getelementptr inbounds [3 x i64]* %n18, i32 0, i64 %14
  %16 = load i64* %arrayidx19, align 8
  %cmp20 = icmp sgt i64 %16, 1
  br i1 %cmp20, label %if.then.21, label %if.end.222

if.then.21:                                       ; preds = %if.end.13
  %17 = load i64* %imax, align 8
  %18 = load %struct.btnode** %btn.addr, align 8
  %n22 = getelementptr inbounds %struct.btnode* %18, i32 0, i32 3
  %arrayidx23 = getelementptr inbounds [3 x i64]* %n22, i32 0, i64 %17
  %19 = load i64* %arrayidx23, align 8
  %div = sdiv i64 %19, 2
  store i64 %div, i64* %n1, align 8
  %20 = load i64* %imax, align 8
  %21 = load %struct.btnode** %btn.addr, align 8
  %n24 = getelementptr inbounds %struct.btnode* %21, i32 0, i32 3
  %arrayidx25 = getelementptr inbounds [3 x i64]* %n24, i32 0, i64 %20
  %22 = load i64* %arrayidx25, align 8
  %23 = load i64* %n1, align 8
  %sub = sub nsw i64 %22, %23
  store i64 %sub, i64* %n2, align 8
  %call = call i8* @ObjectMalloc(i64 6, i64 1)
  %24 = bitcast i8* %call to %struct.btnode*
  store %struct.btnode* %24, %struct.btnode** %btn1, align 8
  %call26 = call i8* @ObjectMalloc(i64 6, i64 1)
  %25 = bitcast i8* %call26 to %struct.btnode*
  store %struct.btnode* %25, %struct.btnode** %btn2, align 8
  %26 = load %struct.btnode** %btn2, align 8
  %btn36 = getelementptr inbounds %struct.btnode* %26, i32 0, i32 7
  %arrayidx37 = getelementptr inbounds [2 x %struct.btnode*]* %btn36, i32 0, i64 0
  store %struct.btnode* null, %struct.btnode** %arrayidx37, align 8
  %27 = load %struct.btnode** %btn2, align 8
  %btn38 = getelementptr inbounds %struct.btnode* %27, i32 0, i32 7
  %arrayidx39 = getelementptr inbounds [2 x %struct.btnode*]* %btn38, i32 0, i64 1
  store %struct.btnode* null, %struct.btnode** %arrayidx39, align 8
  %28 = load %struct.btnode** %btn2, align 8
  %axis40 = getelementptr inbounds %struct.btnode* %28, i32 0, i32 5
  store i64 -1, i64* %axis40, align 8
  %29 = load %struct.btnode** %btn.addr, align 8
  %i = getelementptr inbounds %struct.btnode* %29, i32 0, i32 4
  %arrayidx41 = getelementptr inbounds [3 x i64]* %i, i32 0, i64 0
  %30 = load i64* %arrayidx41, align 8
  %31 = load %struct.btnode** %btn1, align 8
  %i42 = getelementptr inbounds %struct.btnode* %31, i32 0, i32 4
  %arrayidx43 = getelementptr inbounds [3 x i64]* %i42, i32 0, i64 0
  store i64 %30, i64* %arrayidx43, align 8
  %32 = load %struct.btnode** %btn.addr, align 8
  %i44 = getelementptr inbounds %struct.btnode* %32, i32 0, i32 4
  %arrayidx45 = getelementptr inbounds [3 x i64]* %i44, i32 0, i64 1
  %33 = load i64* %arrayidx45, align 8
  %34 = load %struct.btnode** %btn1, align 8
  %i46 = getelementptr inbounds %struct.btnode* %34, i32 0, i32 4
  %arrayidx47 = getelementptr inbounds [3 x i64]* %i46, i32 0, i64 1
  store i64 %33, i64* %arrayidx47, align 8
  %35 = load %struct.btnode** %btn.addr, align 8
  %i48 = getelementptr inbounds %struct.btnode* %35, i32 0, i32 4
  %arrayidx49 = getelementptr inbounds [3 x i64]* %i48, i32 0, i64 2
  %36 = load i64* %arrayidx49, align 8
  %37 = load %struct.btnode** %btn1, align 8
  %i50 = getelementptr inbounds %struct.btnode* %37, i32 0, i32 4
  %arrayidx51 = getelementptr inbounds [3 x i64]* %i50, i32 0, i64 2
  store i64 %36, i64* %arrayidx51, align 8
  %38 = load %struct.btnode** %btn.addr, align 8
  %i52 = getelementptr inbounds %struct.btnode* %38, i32 0, i32 4
  %arrayidx53 = getelementptr inbounds [3 x i64]* %i52, i32 0, i64 0
  %39 = load i64* %arrayidx53, align 8
  %40 = load %struct.btnode** %btn2, align 8
  %i54 = getelementptr inbounds %struct.btnode* %40, i32 0, i32 4
  %arrayidx55 = getelementptr inbounds [3 x i64]* %i54, i32 0, i64 0
  store i64 %39, i64* %arrayidx55, align 8
  %41 = load %struct.btnode** %btn.addr, align 8
  %i56 = getelementptr inbounds %struct.btnode* %41, i32 0, i32 4
  %arrayidx57 = getelementptr inbounds [3 x i64]* %i56, i32 0, i64 1
  %42 = load i64* %arrayidx57, align 8
  %43 = load %struct.btnode** %btn2, align 8
  %i58 = getelementptr inbounds %struct.btnode* %43, i32 0, i32 4
  %arrayidx59 = getelementptr inbounds [3 x i64]* %i58, i32 0, i64 1
  store i64 %42, i64* %arrayidx59, align 8
  %44 = load %struct.btnode** %btn.addr, align 8
  %i60 = getelementptr inbounds %struct.btnode* %44, i32 0, i32 4
  %arrayidx61 = getelementptr inbounds [3 x i64]* %i60, i32 0, i64 2
  %45 = load i64* %arrayidx61, align 8
  %46 = load %struct.btnode** %btn2, align 8
  %i62 = getelementptr inbounds %struct.btnode* %46, i32 0, i32 4
  %arrayidx63 = getelementptr inbounds [3 x i64]* %i62, i32 0, i64 2
  store i64 %45, i64* %arrayidx63, align 8
  %47 = load i64* %n1, align 8
  %48 = load i64* %imax, align 8
  %49 = load %struct.btnode** %btn2, align 8
  %i64 = getelementptr inbounds %struct.btnode* %49, i32 0, i32 4
  %arrayidx65 = getelementptr inbounds [3 x i64]* %i64, i32 0, i64 %48
  %50 = load i64* %arrayidx65, align 8
  %add = add nsw i64 %50, %47
  store i64 %add, i64* %arrayidx65, align 8
  %51 = load %struct.btnode** %btn.addr, align 8
  %n70 = getelementptr inbounds %struct.btnode* %51, i32 0, i32 3
  %arrayidx71 = getelementptr inbounds [3 x i64]* %n70, i32 0, i64 1
  %52 = load i64* %arrayidx71, align 8
  %53 = load %struct.btnode** %btn1, align 8
  %n72 = getelementptr inbounds %struct.btnode* %53, i32 0, i32 3
  %arrayidx73 = getelementptr inbounds [3 x i64]* %n72, i32 0, i64 1
  store i64 %52, i64* %arrayidx73, align 8
  %54 = load %struct.btnode** %btn.addr, align 8
  %n74 = getelementptr inbounds %struct.btnode* %54, i32 0, i32 3
  %arrayidx75 = getelementptr inbounds [3 x i64]* %n74, i32 0, i64 2
  %55 = load i64* %arrayidx75, align 8
  %56 = load %struct.btnode** %btn1, align 8
  %n76 = getelementptr inbounds %struct.btnode* %56, i32 0, i32 3
  %arrayidx77 = getelementptr inbounds [3 x i64]* %n76, i32 0, i64 2
  store i64 %55, i64* %arrayidx77, align 8
  %57 = load %struct.btnode** %btn.addr, align 8
  %n84 = getelementptr inbounds %struct.btnode* %57, i32 0, i32 3
  %arrayidx85 = getelementptr inbounds [3 x i64]* %n84, i32 0, i64 1
  %58 = load i64* %arrayidx85, align 8
  %59 = load %struct.btnode** %btn2, align 8
  %n86 = getelementptr inbounds %struct.btnode* %59, i32 0, i32 3
  %arrayidx87 = getelementptr inbounds [3 x i64]* %n86, i32 0, i64 1
  store i64 %58, i64* %arrayidx87, align 8
  %60 = load %struct.btnode** %btn.addr, align 8
  %n88 = getelementptr inbounds %struct.btnode* %60, i32 0, i32 3
  %arrayidx89 = getelementptr inbounds [3 x i64]* %n88, i32 0, i64 2
  %61 = load i64* %arrayidx89, align 8
  %62 = load %struct.btnode** %btn2, align 8
  %n90 = getelementptr inbounds %struct.btnode* %62, i32 0, i32 3
  %arrayidx91 = getelementptr inbounds [3 x i64]* %n90, i32 0, i64 2
  store i64 %61, i64* %arrayidx91, align 8
  %63 = load i64* %n2, align 8
  %64 = load i64* %imax, align 8
  %65 = load %struct.btnode** %btn2, align 8
  %n92 = getelementptr inbounds %struct.btnode* %65, i32 0, i32 3
  %arrayidx93 = getelementptr inbounds [3 x i64]* %n92, i32 0, i64 %64
  store i64 %63, i64* %arrayidx93, align 8
  %66 = load %struct.btnode** %btn.addr, align 8
  %p = getelementptr inbounds %struct.btnode* %66, i32 0, i32 1
  %arrayidx94 = getelementptr inbounds [3 x double]* %p, i32 0, i64 0
  %67 = load double* %arrayidx94, align 8
  %68 = load %struct.btnode** %btn1, align 8
  %p95 = getelementptr inbounds %struct.btnode* %68, i32 0, i32 1
  %arrayidx96 = getelementptr inbounds [3 x double]* %p95, i32 0, i64 0
  store double %67, double* %arrayidx96, align 8
  %69 = load %struct.btnode** %btn.addr, align 8
  %p97 = getelementptr inbounds %struct.btnode* %69, i32 0, i32 1
  %arrayidx98 = getelementptr inbounds [3 x double]* %p97, i32 0, i64 1
  %70 = load double* %arrayidx98, align 8
  %71 = load %struct.btnode** %btn1, align 8
  %p99 = getelementptr inbounds %struct.btnode* %71, i32 0, i32 1
  %arrayidx100 = getelementptr inbounds [3 x double]* %p99, i32 0, i64 1
  store double %70, double* %arrayidx100, align 8
  %72 = load %struct.btnode** %btn.addr, align 8
  %p101 = getelementptr inbounds %struct.btnode* %72, i32 0, i32 1
  %arrayidx102 = getelementptr inbounds [3 x double]* %p101, i32 0, i64 2
  %73 = load double* %arrayidx102, align 8
  %74 = load %struct.btnode** %btn1, align 8
  %p103 = getelementptr inbounds %struct.btnode* %74, i32 0, i32 1
  %arrayidx104 = getelementptr inbounds [3 x double]* %p103, i32 0, i64 2
  store double %73, double* %arrayidx104, align 8
  %75 = load %struct.btnode** %btn.addr, align 8
  %p105 = getelementptr inbounds %struct.btnode* %75, i32 0, i32 1
  %arrayidx106 = getelementptr inbounds [3 x double]* %p105, i32 0, i64 0
  %76 = load double* %arrayidx106, align 8
  %77 = load %struct.btnode** %btn2, align 8
  %p107 = getelementptr inbounds %struct.btnode* %77, i32 0, i32 1
  %arrayidx108 = getelementptr inbounds [3 x double]* %p107, i32 0, i64 0
  store double %76, double* %arrayidx108, align 8
  %78 = load %struct.btnode** %btn.addr, align 8
  %p109 = getelementptr inbounds %struct.btnode* %78, i32 0, i32 1
  %arrayidx110 = getelementptr inbounds [3 x double]* %p109, i32 0, i64 1
  %79 = load double* %arrayidx110, align 8
  %80 = load %struct.btnode** %btn2, align 8
  %p111 = getelementptr inbounds %struct.btnode* %80, i32 0, i32 1
  %arrayidx112 = getelementptr inbounds [3 x double]* %p111, i32 0, i64 1
  store double %79, double* %arrayidx112, align 8
  %81 = load %struct.btnode** %btn.addr, align 8
  %p113 = getelementptr inbounds %struct.btnode* %81, i32 0, i32 1
  %arrayidx114 = getelementptr inbounds [3 x double]* %p113, i32 0, i64 2
  %82 = load double* %arrayidx114, align 8
  %83 = load %struct.btnode** %btn2, align 8
  %p115 = getelementptr inbounds %struct.btnode* %83, i32 0, i32 1
  %arrayidx116 = getelementptr inbounds [3 x double]* %p115, i32 0, i64 2
  store double %82, double* %arrayidx116, align 8
  %84 = load i64* %imax, align 8
  %85 = load %struct.btnode** %btn.addr, align 8
  %p117 = getelementptr inbounds %struct.btnode* %85, i32 0, i32 1
  %arrayidx118 = getelementptr inbounds [3 x double]* %p117, i32 0, i64 %84
  %86 = load double* %arrayidx118, align 8
  %87 = load i64* %n1, align 8
  %conv = sitofp i64 %87 to double
  %88 = load i64* %imax, align 8
  %89 = load %struct.grid** %g.addr, align 8
  %cellsize = getelementptr inbounds %struct.grid* %89, i32 0, i32 8
  %arrayidx119 = getelementptr inbounds [3 x double]* %cellsize, i32 0, i64 %88
  %90 = load double* %arrayidx119, align 8
  %mul = fmul double %conv, %90
  %add120 = fadd double %86, %mul
  %91 = load i64* %imax, align 8
  %92 = load %struct.btnode** %btn2, align 8
  %p121 = getelementptr inbounds %struct.btnode* %92, i32 0, i32 1
  %arrayidx122 = getelementptr inbounds [3 x double]* %p121, i32 0, i64 %91
  store double %add120, double* %arrayidx122, align 8
  %93 = load %struct.btnode** %btn1, align 8
  %p123 = getelementptr inbounds %struct.btnode* %93, i32 0, i32 1
  %arrayidx124 = getelementptr inbounds [3 x double]* %p123, i32 0, i64 0
  %94 = load double* %arrayidx124, align 8
  %dnear = getelementptr inbounds %struct.bbox* %b1, i32 0, i32 0
  %arrayidx125 = getelementptr inbounds [3 x double]* %dnear, i32 0, i64 0
  store double %94, double* %arrayidx125, align 8
  %95 = load %struct.btnode** %btn1, align 8
  %p126 = getelementptr inbounds %struct.btnode* %95, i32 0, i32 1
  %arrayidx127 = getelementptr inbounds [3 x double]* %p126, i32 0, i64 1
  %96 = load double* %arrayidx127, align 8
  %dnear128 = getelementptr inbounds %struct.bbox* %b1, i32 0, i32 0
  %arrayidx129 = getelementptr inbounds [3 x double]* %dnear128, i32 0, i64 1
  store double %96, double* %arrayidx129, align 8
  %97 = load %struct.btnode** %btn1, align 8
  %p130 = getelementptr inbounds %struct.btnode* %97, i32 0, i32 1
  %arrayidx131 = getelementptr inbounds [3 x double]* %p130, i32 0, i64 2
  %98 = load double* %arrayidx131, align 8
  %dnear132 = getelementptr inbounds %struct.bbox* %b1, i32 0, i32 0
  %arrayidx133 = getelementptr inbounds [3 x double]* %dnear132, i32 0, i64 2
  store double %98, double* %arrayidx133, align 8
  %99 = load %struct.btnode** %btn1, align 8
  %p134 = getelementptr inbounds %struct.btnode* %99, i32 0, i32 1
  %arrayidx135 = getelementptr inbounds [3 x double]* %p134, i32 0, i64 0
  %100 = load double* %arrayidx135, align 8
  %101 = load %struct.btnode** %btn1, align 8
  %n136 = getelementptr inbounds %struct.btnode* %101, i32 0, i32 3
  %arrayidx137 = getelementptr inbounds [3 x i64]* %n136, i32 0, i64 0
  %102 = load i64* %arrayidx137, align 8
  %conv138 = sitofp i64 %102 to double
  %103 = load %struct.grid** %g.addr, align 8
  %cellsize139 = getelementptr inbounds %struct.grid* %103, i32 0, i32 8
  %arrayidx140 = getelementptr inbounds [3 x double]* %cellsize139, i32 0, i64 0
  %104 = load double* %arrayidx140, align 8
  %mul141 = fmul double %conv138, %104
  %add142 = fadd double %100, %mul141
  %dfar = getelementptr inbounds %struct.bbox* %b1, i32 0, i32 1
  %arrayidx143 = getelementptr inbounds [3 x double]* %dfar, i32 0, i64 0
  store double %add142, double* %arrayidx143, align 8
  %105 = load %struct.btnode** %btn1, align 8
  %p144 = getelementptr inbounds %struct.btnode* %105, i32 0, i32 1
  %arrayidx145 = getelementptr inbounds [3 x double]* %p144, i32 0, i64 1
  %106 = load double* %arrayidx145, align 8
  %107 = load %struct.btnode** %btn1, align 8
  %n146 = getelementptr inbounds %struct.btnode* %107, i32 0, i32 3
  %arrayidx147 = getelementptr inbounds [3 x i64]* %n146, i32 0, i64 1
  %108 = load i64* %arrayidx147, align 8
  %conv148 = sitofp i64 %108 to double
  %109 = load %struct.grid** %g.addr, align 8
  %cellsize149 = getelementptr inbounds %struct.grid* %109, i32 0, i32 8
  %arrayidx150 = getelementptr inbounds [3 x double]* %cellsize149, i32 0, i64 1
  %110 = load double* %arrayidx150, align 8
  %mul151 = fmul double %conv148, %110
  %add152 = fadd double %106, %mul151
  %dfar153 = getelementptr inbounds %struct.bbox* %b1, i32 0, i32 1
  %arrayidx154 = getelementptr inbounds [3 x double]* %dfar153, i32 0, i64 1
  store double %add152, double* %arrayidx154, align 8
  %111 = load %struct.btnode** %btn1, align 8
  %p155 = getelementptr inbounds %struct.btnode* %111, i32 0, i32 1
  %arrayidx156 = getelementptr inbounds [3 x double]* %p155, i32 0, i64 2
  %112 = load double* %arrayidx156, align 8
  %113 = load %struct.btnode** %btn1, align 8
  %n157 = getelementptr inbounds %struct.btnode* %113, i32 0, i32 3
  %arrayidx158 = getelementptr inbounds [3 x i64]* %n157, i32 0, i64 2
  %114 = load i64* %arrayidx158, align 8
  %conv159 = sitofp i64 %114 to double
  %115 = load %struct.grid** %g.addr, align 8
  %cellsize160 = getelementptr inbounds %struct.grid* %115, i32 0, i32 8
  %arrayidx161 = getelementptr inbounds [3 x double]* %cellsize160, i32 0, i64 2
  %116 = load double* %arrayidx161, align 8
  %mul162 = fmul double %conv159, %116
  %add163 = fadd double %112, %mul162
  %dfar164 = getelementptr inbounds %struct.bbox* %b1, i32 0, i32 1
  %arrayidx165 = getelementptr inbounds [3 x double]* %dfar164, i32 0, i64 2
  store double %add163, double* %arrayidx165, align 8
  %117 = load %struct.btnode** %btn.addr, align 8
  %pe = getelementptr inbounds %struct.btnode* %117, i32 0, i32 0
  %118 = load %struct.element*** %pe, align 8
  %119 = load %struct.btnode** %btn.addr, align 8
  %nprims = getelementptr inbounds %struct.btnode* %119, i32 0, i32 2
  %120 = load i64* %nprims, align 8
  %121 = load %struct.btnode** %btn1, align 8
  %nprims166 = getelementptr inbounds %struct.btnode* %121, i32 0, i32 2
  %call167 = call %struct.element** @prims_in_box2(%struct.element** %118, i64 %120, %struct.bbox* byval align 8 %b1, i64* %nprims166)
  %122 = load %struct.btnode** %btn1, align 8
  %pe168 = getelementptr inbounds %struct.btnode* %122, i32 0, i32 0
  store %struct.element** %call167, %struct.element*** %pe168, align 8
  %123 = load %struct.btnode** %btn.addr, align 8
  %nprims169 = getelementptr inbounds %struct.btnode* %123, i32 0, i32 2
  %124 = load i64* %nprims169, align 8
  %125 = load %struct.btnode** %btn1, align 8
  %totalPrimsAllocated = getelementptr inbounds %struct.btnode* %125, i32 0, i32 6
  store i64 %124, i64* %totalPrimsAllocated, align 8
  %126 = load %struct.btnode** %btn2, align 8
  %p170 = getelementptr inbounds %struct.btnode* %126, i32 0, i32 1
  %arrayidx171 = getelementptr inbounds [3 x double]* %p170, i32 0, i64 0
  %127 = load double* %arrayidx171, align 8
  %dnear172 = getelementptr inbounds %struct.bbox* %b2, i32 0, i32 0
  %arrayidx173 = getelementptr inbounds [3 x double]* %dnear172, i32 0, i64 0
  store double %127, double* %arrayidx173, align 8
  %128 = load %struct.btnode** %btn2, align 8
  %p174 = getelementptr inbounds %struct.btnode* %128, i32 0, i32 1
  %arrayidx175 = getelementptr inbounds [3 x double]* %p174, i32 0, i64 1
  %129 = load double* %arrayidx175, align 8
  %dnear176 = getelementptr inbounds %struct.bbox* %b2, i32 0, i32 0
  %arrayidx177 = getelementptr inbounds [3 x double]* %dnear176, i32 0, i64 1
  store double %129, double* %arrayidx177, align 8
  %130 = load %struct.btnode** %btn2, align 8
  %p178 = getelementptr inbounds %struct.btnode* %130, i32 0, i32 1
  %arrayidx179 = getelementptr inbounds [3 x double]* %p178, i32 0, i64 2
  %131 = load double* %arrayidx179, align 8
  %dnear180 = getelementptr inbounds %struct.bbox* %b2, i32 0, i32 0
  %arrayidx181 = getelementptr inbounds [3 x double]* %dnear180, i32 0, i64 2
  store double %131, double* %arrayidx181, align 8
  %132 = load %struct.btnode** %btn2, align 8
  %p182 = getelementptr inbounds %struct.btnode* %132, i32 0, i32 1
  %arrayidx183 = getelementptr inbounds [3 x double]* %p182, i32 0, i64 0
  %133 = load double* %arrayidx183, align 8
  %134 = load %struct.btnode** %btn2, align 8
  %n184 = getelementptr inbounds %struct.btnode* %134, i32 0, i32 3
  %arrayidx185 = getelementptr inbounds [3 x i64]* %n184, i32 0, i64 0
  %135 = load i64* %arrayidx185, align 8
  %conv186 = sitofp i64 %135 to double
  %136 = load %struct.grid** %g.addr, align 8
  %cellsize187 = getelementptr inbounds %struct.grid* %136, i32 0, i32 8
  %arrayidx188 = getelementptr inbounds [3 x double]* %cellsize187, i32 0, i64 0
  %137 = load double* %arrayidx188, align 8
  %mul189 = fmul double %conv186, %137
  %add190 = fadd double %133, %mul189
  %dfar191 = getelementptr inbounds %struct.bbox* %b2, i32 0, i32 1
  %arrayidx192 = getelementptr inbounds [3 x double]* %dfar191, i32 0, i64 0
  store double %add190, double* %arrayidx192, align 8
  %138 = load %struct.btnode** %btn2, align 8
  %p193 = getelementptr inbounds %struct.btnode* %138, i32 0, i32 1
  %arrayidx194 = getelementptr inbounds [3 x double]* %p193, i32 0, i64 1
  %139 = load double* %arrayidx194, align 8
  %140 = load %struct.btnode** %btn2, align 8
  %n195 = getelementptr inbounds %struct.btnode* %140, i32 0, i32 3
  %arrayidx196 = getelementptr inbounds [3 x i64]* %n195, i32 0, i64 1
  %141 = load i64* %arrayidx196, align 8
  %conv197 = sitofp i64 %141 to double
  %142 = load %struct.grid** %g.addr, align 8
  %cellsize198 = getelementptr inbounds %struct.grid* %142, i32 0, i32 8
  %arrayidx199 = getelementptr inbounds [3 x double]* %cellsize198, i32 0, i64 1
  %143 = load double* %arrayidx199, align 8
  %mul200 = fmul double %conv197, %143
  %add201 = fadd double %139, %mul200
  %dfar202 = getelementptr inbounds %struct.bbox* %b2, i32 0, i32 1
  %arrayidx203 = getelementptr inbounds [3 x double]* %dfar202, i32 0, i64 1
  store double %add201, double* %arrayidx203, align 8
  %144 = load %struct.btnode** %btn2, align 8
  %p204 = getelementptr inbounds %struct.btnode* %144, i32 0, i32 1
  %arrayidx205 = getelementptr inbounds [3 x double]* %p204, i32 0, i64 2
  %145 = load double* %arrayidx205, align 8
  %146 = load %struct.btnode** %btn2, align 8
  %n206 = getelementptr inbounds %struct.btnode* %146, i32 0, i32 3
  %arrayidx207 = getelementptr inbounds [3 x i64]* %n206, i32 0, i64 2
  %147 = load i64* %arrayidx207, align 8
  %conv208 = sitofp i64 %147 to double
  %148 = load %struct.grid** %g.addr, align 8
  %cellsize209 = getelementptr inbounds %struct.grid* %148, i32 0, i32 8
  %arrayidx210 = getelementptr inbounds [3 x double]* %cellsize209, i32 0, i64 2
  %149 = load double* %arrayidx210, align 8
  %mul211 = fmul double %conv208, %149
  %add212 = fadd double %145, %mul211
  %dfar213 = getelementptr inbounds %struct.bbox* %b2, i32 0, i32 1
  %arrayidx214 = getelementptr inbounds [3 x double]* %dfar213, i32 0, i64 2
  store double %add212, double* %arrayidx214, align 8
  %150 = load %struct.btnode** %btn.addr, align 8
  %pe215 = getelementptr inbounds %struct.btnode* %150, i32 0, i32 0
  %151 = load %struct.element*** %pe215, align 8
  %152 = load %struct.btnode** %btn.addr, align 8
  %nprims216 = getelementptr inbounds %struct.btnode* %152, i32 0, i32 2
  %153 = load i64* %nprims216, align 8
  %154 = load %struct.btnode** %btn2, align 8
  %nprims217 = getelementptr inbounds %struct.btnode* %154, i32 0, i32 2
  %call218 = call %struct.element** @prims_in_box2(%struct.element** %151, i64 %153, %struct.bbox* byval align 8 %b2, i64* %nprims217)
  %155 = load %struct.btnode** %btn2, align 8
  %pe219 = getelementptr inbounds %struct.btnode* %155, i32 0, i32 0
  store %struct.element** %call218, %struct.element*** %pe219, align 8
  %156 = load %struct.btnode** %btn.addr, align 8
  %nprims220 = getelementptr inbounds %struct.btnode* %156, i32 0, i32 2
  %157 = load i64* %nprims220, align 8
  %158 = load %struct.btnode** %btn2, align 8
  %totalPrimsAllocated221 = getelementptr inbounds %struct.btnode* %158, i32 0, i32 6
  store i64 %157, i64* %totalPrimsAllocated221, align 8
  br label %if.end.222

if.end.222:                                       ; preds = %if.then.21, %if.end.13
  br label %if.end.237

land.lhs.true:                                    ; No predecessors!
  br label %if.end.237

land.lhs.true.231:                                ; No predecessors!
  br label %if.end.237

if.then.236:                                      ; No predecessors!
  br label %if.end.237

if.end.237:                                       ; preds = %land.lhs.true.231, %land.lhs.true, %if.end.222, %if.then.236
  br label %if.end.253

land.lhs.true.242:                                ; No predecessors!
  br label %if.end.253

land.lhs.true.247:                                ; No predecessors!
  br label %if.end.253

if.then.252:                                      ; No predecessors!
  br label %if.end.253

if.end.253:                                       ; preds = %land.lhs.true.247, %land.lhs.true.242, %if.end.237, %if.then.252
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @create_bintree(%struct.btnode* %root, %struct.grid* %g) {
entry:
  %root.addr = alloca %struct.btnode*, align 8
  %g.addr = alloca %struct.grid*, align 8
  %btn = alloca %struct.btnode*, align 8
  store %struct.btnode* %root, %struct.btnode** %root.addr, align 8
  store %struct.grid* %g, %struct.grid** %g.addr, align 8
  %0 = load %struct.btnode** %root.addr, align 8
  store %struct.btnode* %0, %struct.btnode** %btn, align 8
  %1 = load %struct.btnode** %btn, align 8
  %n = getelementptr inbounds %struct.btnode* %1, i32 0, i32 3
  %arrayidx = getelementptr inbounds [3 x i64]* %n, i32 0, i64 0
  %2 = load i64* %arrayidx, align 8
  %cmp = icmp ne i64 %2, 1
  br i1 %cmp, label %if.then, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %entry
  %3 = load %struct.btnode** %btn, align 8
  %n1 = getelementptr inbounds %struct.btnode* %3, i32 0, i32 3
  %arrayidx2 = getelementptr inbounds [3 x i64]* %n1, i32 0, i64 1
  %4 = load i64* %arrayidx2, align 8
  %cmp3 = icmp ne i64 %4, 1
  br i1 %cmp3, label %if.then, label %lor.lhs.false.4

lor.lhs.false.4:                                  ; preds = %lor.lhs.false
  %5 = load %struct.btnode** %btn, align 8
  %n5 = getelementptr inbounds %struct.btnode* %5, i32 0, i32 3
  %arrayidx6 = getelementptr inbounds [3 x i64]* %n5, i32 0, i64 2
  %6 = load i64* %arrayidx6, align 8
  %cmp7 = icmp ne i64 %6, 1
  br i1 %cmp7, label %if.then, label %if.end.14

if.then:                                          ; preds = %lor.lhs.false.4, %lor.lhs.false, %entry
  %7 = load %struct.btnode** %btn, align 8
  %8 = load %struct.grid** %g.addr, align 8
  call void @subdiv_bintree(%struct.btnode* %7, %struct.grid* %8)
  %9 = load %struct.btnode** %btn, align 8
  %btn8 = getelementptr inbounds %struct.btnode* %9, i32 0, i32 7
  %arrayidx9 = getelementptr inbounds [2 x %struct.btnode*]* %btn8, i32 0, i64 0
  %10 = load %struct.btnode** %arrayidx9, align 8
  %11 = load %struct.grid** %g.addr, align 8
  call void @create_bintree(%struct.btnode* %10, %struct.grid* %11)
  %12 = load %struct.btnode** %btn, align 8
  %btn10 = getelementptr inbounds %struct.btnode* %12, i32 0, i32 7
  %arrayidx11 = getelementptr inbounds [2 x %struct.btnode*]* %btn10, i32 0, i64 1
  %13 = load %struct.btnode** %arrayidx11, align 8
  %14 = load %struct.grid** %g.addr, align 8
  call void @create_bintree(%struct.btnode* %13, %struct.grid* %14)
  br label %if.end

if.then.13:                                       ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %if.then, %if.then.13
  br label %if.end.14

if.end.14:                                        ; preds = %if.end, %lor.lhs.false.4
  ret void
}

; Function Attrs: nounwind uwtable
define internal %struct.element** @bintree_lookup(%struct.btnode* %root, i64 %i, i64 %j, i64 %k, %struct.grid* %g, i64* %n) {
entry:
  %retval = alloca %struct.element**, align 8
  %root.addr = alloca %struct.btnode*, align 8
  %i.addr = alloca i64, align 8
  %j.addr = alloca i64, align 8
  %k.addr = alloca i64, align 8
  %g.addr = alloca %struct.grid*, align 8
  %n.addr = alloca i64*, align 8
  %l = alloca i64, align 8
  %x = alloca i64, align 8
  %ijk = alloca [3 x i64], align 16
  %child = alloca i64, align 8
  %idiv = alloca i64, align 8
  %pepa = alloca %struct.element**, align 8
  %btn = alloca %struct.btnode*, align 8
  store %struct.btnode* %root, %struct.btnode** %root.addr, align 8
  store i64 %i, i64* %i.addr, align 8
  store i64* %n, i64** %n.addr, align 8
  %0 = load i64* %i.addr, align 8
  %arrayidx = getelementptr inbounds [3 x i64]* %ijk, i32 0, i64 0
  store i64 %0, i64* %arrayidx, align 8
  %1 = load %struct.btnode** %root.addr, align 8
  store %struct.btnode* %1, %struct.btnode** %btn, align 8
  %2 = load %struct.btnode** %btn, align 8
  %cmp = icmp eq %struct.btnode* %2, null
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %3 = load i64** %n.addr, align 8
  store i64 0, i64* %3, align 8
  store %struct.element** null, %struct.element*** %retval
  br label %return

if.end:                                           ; preds = %entry
  br label %while.cond

while.cond:                                       ; preds = %if.end.36, %if.end
  %4 = load %struct.btnode** %btn, align 8
  %n3 = getelementptr inbounds %struct.btnode* %4, i32 0, i32 3
  %arrayidx4 = getelementptr inbounds [3 x i64]* %n3, i32 0, i64 0
  %5 = load i64* %arrayidx4, align 8
  %cmp5 = icmp ne i64 %5, 1
  br i1 %cmp5, label %lor.end, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %while.cond
  %6 = load %struct.btnode** %btn, align 8
  %n6 = getelementptr inbounds %struct.btnode* %6, i32 0, i32 3
  %arrayidx7 = getelementptr inbounds [3 x i64]* %n6, i32 0, i64 1
  %7 = load i64* %arrayidx7, align 8
  %cmp8 = icmp ne i64 %7, 1
  br i1 %cmp8, label %lor.end, label %lor.rhs

lor.rhs:                                          ; preds = %lor.lhs.false
  %8 = load %struct.btnode** %btn, align 8
  %n9 = getelementptr inbounds %struct.btnode* %8, i32 0, i32 3
  %arrayidx10 = getelementptr inbounds [3 x i64]* %n9, i32 0, i64 2
  %9 = load i64* %arrayidx10, align 8
  %cmp11 = icmp ne i64 %9, 1
  br label %lor.end

lor.end:                                          ; preds = %lor.rhs, %lor.lhs.false, %while.cond
  %10 = phi i1 [ true, %lor.lhs.false ], [ true, %while.cond ], [ %cmp11, %lor.rhs ]
  br i1 %10, label %while.body, label %while.end

while.body:                                       ; preds = %lor.end
  %11 = load %struct.btnode** %btn, align 8
  %axis = getelementptr inbounds %struct.btnode* %11, i32 0, i32 5
  %12 = load i64* %axis, align 8
  %cmp12 = icmp eq i64 %12, -1
  br i1 %cmp12, label %if.then.13, label %if.end.21

if.then.13:                                       ; preds = %while.body
  unreachable

if.end.21:                                        ; preds = %while.body
  store i64 0, i64* %child, align 8
  %13 = load %struct.btnode** %btn, align 8
  %axis22 = getelementptr inbounds %struct.btnode* %13, i32 0, i32 5
  %14 = load i64* %axis22, align 8
  %15 = load %struct.btnode** %btn, align 8
  %n23 = getelementptr inbounds %struct.btnode* %15, i32 0, i32 3
  %arrayidx24 = getelementptr inbounds [3 x i64]* %n23, i32 0, i64 %14
  %16 = load i64* %arrayidx24, align 8
  %div = sdiv i64 %16, 2
  store i64 %div, i64* %idiv, align 8
  %17 = load %struct.btnode** %btn, align 8
  %axis25 = getelementptr inbounds %struct.btnode* %17, i32 0, i32 5
  %18 = load i64* %axis25, align 8
  %arrayidx26 = getelementptr inbounds [3 x i64]* %ijk, i32 0, i64 %18
  %19 = load i64* %arrayidx26, align 8
  %add = add nsw i64 %19, 1
  %20 = load i64* %idiv, align 8
  %cmp27 = icmp sgt i64 %add, %20
  br i1 %cmp27, label %if.then.28, label %if.end.31

if.then.28:                                       ; preds = %if.end.21
  store i64 1, i64* %child, align 8
  %21 = load i64* %idiv, align 8
  %22 = load %struct.btnode** %btn, align 8
  %axis29 = getelementptr inbounds %struct.btnode* %22, i32 0, i32 5
  %23 = load i64* %axis29, align 8
  %arrayidx30 = getelementptr inbounds [3 x i64]* %ijk, i32 0, i64 %23
  %24 = load i64* %arrayidx30, align 8
  %sub = sub nsw i64 %24, %21
  store i64 %sub, i64* %arrayidx30, align 8
  br label %if.end.31

if.end.31:                                        ; preds = %if.then.28, %if.end.21
  %25 = load i64* %child, align 8
  %26 = load %struct.btnode** %btn, align 8
  %btn32 = getelementptr inbounds %struct.btnode* %26, i32 0, i32 7
  %arrayidx33 = getelementptr inbounds [2 x %struct.btnode*]* %btn32, i32 0, i64 %25
  %27 = load %struct.btnode** %arrayidx33, align 8
  store %struct.btnode* %27, %struct.btnode** %btn, align 8
  %28 = load %struct.btnode** %btn, align 8
  %cmp34 = icmp eq %struct.btnode* %28, null
  br i1 %cmp34, label %if.then.35, label %if.end.36

if.then.35:                                       ; preds = %if.end.31
  %29 = load i64** %n.addr, align 8
  store i64 0, i64* %29, align 8
  store %struct.element** null, %struct.element*** %retval
  br label %return

if.end.36:                                        ; preds = %if.end.31
  br label %while.cond

while.end:                                        ; preds = %lor.end
  %30 = load %struct.btnode** %btn, align 8
  %nprims37 = getelementptr inbounds %struct.btnode* %30, i32 0, i32 2
  %31 = load i64* %nprims37, align 8
  %32 = load i64** %n.addr, align 8
  store i64 %31, i64* %32, align 8
  %33 = load %struct.btnode** %btn, align 8
  %pe = getelementptr inbounds %struct.btnode* %33, i32 0, i32 0
  %34 = load %struct.element*** %pe, align 8
  store %struct.element** %34, %struct.element*** %pepa, align 8
  %35 = load %struct.element*** %pepa, align 8
  store %struct.element** %35, %struct.element*** %retval
  br label %return

return:                                           ; preds = %while.end, %if.then.35, %if.then
  %36 = load %struct.element*** %retval
  ret %struct.element** %36
}

; Function Attrs: noreturn
declare void @exit(i32)

; Function Attrs: nounwind uwtable
define internal void @deleteBinTree(%struct.btnode* %binTree) {
entry:
  %binTree.addr = alloca %struct.btnode*, align 8
  %left = alloca %struct.btnode*, align 8
  %right = alloca %struct.btnode*, align 8
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %entry, %if.then
  ret void
}

; Function Attrs: nounwind uwtable
define internal %struct.grid* @create_grid(%struct.voxel* %v, %struct.grid* %g, i64 %num_prims) {
entry:
  %v.addr = alloca %struct.voxel*, align 8
  %g.addr = alloca %struct.grid*, align 8
  %num_prims.addr = alloca i64, align 8
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %k = alloca i64, align 8
  %r = alloca i64, align 8
  %nprims = alloca i64, align 8
  %index1D = alloca i64, align 8
  %ec = alloca i64*, align 8
  %pc = alloca i64*, align 8
  %nec = alloca double, align 8
  %unsgn = alloca double, align 8
  %ncells = alloca double, align 8
  %ng = alloca %struct.grid*, align 8
  %nng = alloca %struct.grid*, align 8
  %b = alloca %struct.bbox, align 8
  %nv = alloca %struct.voxel*, align 8
  %ht = alloca %struct.voxel**, align 8
  %bintree = alloca %struct.btnode*, align 8
  %pepa = alloca %struct.element**, align 8
  store %struct.voxel* %v, %struct.voxel** %v.addr, align 8
  store %struct.grid* %g, %struct.grid** %g.addr, align 8
  store i64 %num_prims, i64* %num_prims.addr, align 8
  %call = call i8* @ObjectMalloc(i64 0, i64 1)
  %0 = bitcast i8* %call to %struct.grid*
  store %struct.grid* %0, %struct.grid** %ng, align 8
  %1 = load i64* @grids, align 8
  %inc = add nsw i64 %1, 1
  store i64 %inc, i64* @grids, align 8
  %2 = load %struct.grid** %ng, align 8
  %id = getelementptr inbounds %struct.grid* %2, i32 0, i32 0
  store i64 %1, i64* %id, align 8
  %3 = load i64* @hu_numbuckets, align 8
  %call1 = call i8* @ObjectMalloc(i64 2, i64 %3)
  %4 = bitcast i8* %call1 to %struct.voxel**
  store %struct.voxel** %4, %struct.voxel*** %ht, align 8
  %5 = load %struct.voxel*** %ht, align 8
  %6 = load %struct.grid** %ng, align 8
  %hashtable = getelementptr inbounds %struct.grid* %6, i32 0, i32 1
  store %struct.voxel** %5, %struct.voxel*** %hashtable, align 8
  %7 = load i64* @hu_gridsize, align 8
  %8 = load i64* @hu_gridsize, align 8
  %mul = mul nsw i64 %7, %8
  %9 = load i64* @hu_gridsize, align 8
  %mul2 = mul nsw i64 %mul, %9
  %conv = sitofp i64 %mul2 to double
  store double %conv, double* %ncells, align 8
  %10 = load double* %ncells, align 8
  %conv5 = fptosi double %10 to i64
  %call6 = call i8* @ObjectMalloc(i64 3, i64 %conv5)
  %11 = bitcast i8* %call6 to i64*
  store i64* %11, i64** %ec, align 8
  %12 = load i64** %ec, align 8
  %13 = load %struct.grid** %ng, align 8
  %emptycells = getelementptr inbounds %struct.grid* %13, i32 0, i32 2
  store i64* %12, i64** %emptycells, align 8
  %14 = load i64* %num_prims.addr, align 8
  %15 = load %struct.grid** %ng, align 8
  %num_prims7 = getelementptr inbounds %struct.grid* %15, i32 0, i32 4
  store i64 %14, i64* %num_prims7, align 8
  %16 = load %struct.voxel** %v.addr, align 8
  %cell = getelementptr inbounds %struct.voxel* %16, i32 0, i32 1
  %17 = load i8** %cell, align 8
  %18 = bitcast i8* %17 to %struct.element**
  %19 = load %struct.grid** %ng, align 8
  %pepa8 = getelementptr inbounds %struct.grid* %19, i32 0, i32 3
  store %struct.element** %18, %struct.element*** %pepa8, align 8
  %20 = load %struct.grid** %ng, align 8
  %indx_inc = getelementptr inbounds %struct.grid* %20, i32 0, i32 5
  %arrayidx = getelementptr inbounds [3 x i64]* %indx_inc, i32 0, i64 0
  store i64 1, i64* %arrayidx, align 8
  %21 = load i64* @hu_gridsize, align 8
  %22 = load %struct.grid** %ng, align 8
  %indx_inc9 = getelementptr inbounds %struct.grid* %22, i32 0, i32 5
  %arrayidx10 = getelementptr inbounds [3 x i64]* %indx_inc9, i32 0, i64 1
  store i64 %21, i64* %arrayidx10, align 8
  %23 = load i64* @hu_gridsize, align 8
  %24 = load i64* @hu_gridsize, align 8
  %mul11 = mul nsw i64 %23, %24
  %25 = load %struct.grid** %ng, align 8
  %indx_inc12 = getelementptr inbounds %struct.grid* %25, i32 0, i32 5
  %arrayidx13 = getelementptr inbounds [3 x i64]* %indx_inc12, i32 0, i64 2
  store i64 %mul11, i64* %arrayidx13, align 8
  %26 = load i64* @hu_numbuckets, align 8
  %27 = load %struct.grid** %ng, align 8
  %num_buckets = getelementptr inbounds %struct.grid* %27, i32 0, i32 6
  store i64 %26, i64* %num_buckets, align 8
  %28 = load %struct.voxel** %v.addr, align 8
  %id14 = getelementptr inbounds %struct.voxel* %28, i32 0, i32 0
  %29 = load i64* %id14, align 8
  %30 = load %struct.grid** %g.addr, align 8
  %indx_inc15 = getelementptr inbounds %struct.grid* %30, i32 0, i32 5
  %arrayidx16 = getelementptr inbounds [3 x i64]* %indx_inc15, i32 0, i64 2
  %31 = load i64* %arrayidx16, align 8
  %div = sdiv i64 %29, %31
  store i64 %div, i64* %k, align 8
  %32 = load %struct.voxel** %v.addr, align 8
  %id17 = getelementptr inbounds %struct.voxel* %32, i32 0, i32 0
  %33 = load i64* %id17, align 8
  %34 = load i64* %k, align 8
  %35 = load %struct.grid** %g.addr, align 8
  %indx_inc18 = getelementptr inbounds %struct.grid* %35, i32 0, i32 5
  %arrayidx19 = getelementptr inbounds [3 x i64]* %indx_inc18, i32 0, i64 2
  %36 = load i64* %arrayidx19, align 8
  %mul20 = mul nsw i64 %34, %36
  %sub = sub nsw i64 %33, %mul20
  store i64 %sub, i64* %r, align 8
  %37 = load i64* %r, align 8
  %38 = load %struct.grid** %g.addr, align 8
  %indx_inc21 = getelementptr inbounds %struct.grid* %38, i32 0, i32 5
  %arrayidx22 = getelementptr inbounds [3 x i64]* %indx_inc21, i32 0, i64 1
  %39 = load i64* %arrayidx22, align 8
  %div23 = sdiv i64 %37, %39
  store i64 %div23, i64* %j, align 8
  %40 = load i64* %r, align 8
  %41 = load i64* %j, align 8
  %42 = load %struct.grid** %g.addr, align 8
  %indx_inc24 = getelementptr inbounds %struct.grid* %42, i32 0, i32 5
  %arrayidx25 = getelementptr inbounds [3 x i64]* %indx_inc24, i32 0, i64 1
  %43 = load i64* %arrayidx25, align 8
  %mul26 = mul nsw i64 %41, %43
  %sub27 = sub nsw i64 %40, %mul26
  store i64 %sub27, i64* %i, align 8
  %44 = load %struct.grid** %g.addr, align 8
  %min = getelementptr inbounds %struct.grid* %44, i32 0, i32 7
  %arrayidx28 = getelementptr inbounds [3 x double]* %min, i32 0, i64 0
  %45 = load double* %arrayidx28, align 8
  %46 = load i64* %i, align 8
  %conv29 = sitofp i64 %46 to double
  %47 = load %struct.grid** %g.addr, align 8
  %cellsize = getelementptr inbounds %struct.grid* %47, i32 0, i32 8
  %arrayidx30 = getelementptr inbounds [3 x double]* %cellsize, i32 0, i64 0
  %48 = load double* %arrayidx30, align 8
  %mul31 = fmul double %conv29, %48
  %add32 = fadd double %45, %mul31
  %49 = load %struct.grid** %ng, align 8
  %min33 = getelementptr inbounds %struct.grid* %49, i32 0, i32 7
  %arrayidx34 = getelementptr inbounds [3 x double]* %min33, i32 0, i64 0
  store double %add32, double* %arrayidx34, align 8
  %50 = load %struct.grid** %g.addr, align 8
  %min35 = getelementptr inbounds %struct.grid* %50, i32 0, i32 7
  %arrayidx36 = getelementptr inbounds [3 x double]* %min35, i32 0, i64 1
  %51 = load double* %arrayidx36, align 8
  %52 = load i64* %j, align 8
  %conv37 = sitofp i64 %52 to double
  %53 = load %struct.grid** %g.addr, align 8
  %cellsize38 = getelementptr inbounds %struct.grid* %53, i32 0, i32 8
  %arrayidx39 = getelementptr inbounds [3 x double]* %cellsize38, i32 0, i64 1
  %54 = load double* %arrayidx39, align 8
  %mul40 = fmul double %conv37, %54
  %add41 = fadd double %51, %mul40
  %55 = load %struct.grid** %ng, align 8
  %min42 = getelementptr inbounds %struct.grid* %55, i32 0, i32 7
  %arrayidx43 = getelementptr inbounds [3 x double]* %min42, i32 0, i64 1
  store double %add41, double* %arrayidx43, align 8
  %56 = load %struct.grid** %g.addr, align 8
  %min44 = getelementptr inbounds %struct.grid* %56, i32 0, i32 7
  %arrayidx45 = getelementptr inbounds [3 x double]* %min44, i32 0, i64 2
  %57 = load double* %arrayidx45, align 8
  %58 = load i64* %k, align 8
  %conv46 = sitofp i64 %58 to double
  %59 = load %struct.grid** %g.addr, align 8
  %cellsize47 = getelementptr inbounds %struct.grid* %59, i32 0, i32 8
  %arrayidx48 = getelementptr inbounds [3 x double]* %cellsize47, i32 0, i64 2
  %60 = load double* %arrayidx48, align 8
  %mul49 = fmul double %conv46, %60
  %add50 = fadd double %57, %mul49
  %61 = load %struct.grid** %ng, align 8
  %min51 = getelementptr inbounds %struct.grid* %61, i32 0, i32 7
  %arrayidx52 = getelementptr inbounds [3 x double]* %min51, i32 0, i64 2
  store double %add50, double* %arrayidx52, align 8
  %62 = load %struct.grid** %g.addr, align 8
  %cellsize53 = getelementptr inbounds %struct.grid* %62, i32 0, i32 8
  %arrayidx54 = getelementptr inbounds [3 x double]* %cellsize53, i32 0, i64 0
  %63 = load double* %arrayidx54, align 8
  %64 = load %struct.grid** %ng, align 8
  %indx_inc55 = getelementptr inbounds %struct.grid* %64, i32 0, i32 5
  %arrayidx56 = getelementptr inbounds [3 x i64]* %indx_inc55, i32 0, i64 1
  %65 = load i64* %arrayidx56, align 8
  %conv57 = sitofp i64 %65 to double
  %div58 = fdiv double %63, %conv57
  %66 = load %struct.grid** %ng, align 8
  %cellsize59 = getelementptr inbounds %struct.grid* %66, i32 0, i32 8
  %arrayidx60 = getelementptr inbounds [3 x double]* %cellsize59, i32 0, i64 0
  store double %div58, double* %arrayidx60, align 8
  %67 = load %struct.grid** %g.addr, align 8
  %cellsize61 = getelementptr inbounds %struct.grid* %67, i32 0, i32 8
  %arrayidx62 = getelementptr inbounds [3 x double]* %cellsize61, i32 0, i64 1
  %68 = load double* %arrayidx62, align 8
  %69 = load %struct.grid** %ng, align 8
  %indx_inc63 = getelementptr inbounds %struct.grid* %69, i32 0, i32 5
  %arrayidx64 = getelementptr inbounds [3 x i64]* %indx_inc63, i32 0, i64 1
  %70 = load i64* %arrayidx64, align 8
  %conv65 = sitofp i64 %70 to double
  %div66 = fdiv double %68, %conv65
  %71 = load %struct.grid** %ng, align 8
  %cellsize67 = getelementptr inbounds %struct.grid* %71, i32 0, i32 8
  %arrayidx68 = getelementptr inbounds [3 x double]* %cellsize67, i32 0, i64 1
  store double %div66, double* %arrayidx68, align 8
  %72 = load %struct.grid** %g.addr, align 8
  %cellsize69 = getelementptr inbounds %struct.grid* %72, i32 0, i32 8
  %arrayidx70 = getelementptr inbounds [3 x double]* %cellsize69, i32 0, i64 2
  %73 = load double* %arrayidx70, align 8
  %74 = load %struct.grid** %ng, align 8
  %indx_inc71 = getelementptr inbounds %struct.grid* %74, i32 0, i32 5
  %arrayidx72 = getelementptr inbounds [3 x i64]* %indx_inc71, i32 0, i64 1
  %75 = load i64* %arrayidx72, align 8
  %conv73 = sitofp i64 %75 to double
  %div74 = fdiv double %73, %conv73
  %76 = load %struct.grid** %ng, align 8
  %cellsize75 = getelementptr inbounds %struct.grid* %76, i32 0, i32 8
  %arrayidx76 = getelementptr inbounds [3 x double]* %cellsize75, i32 0, i64 2
  store double %div74, double* %arrayidx76, align 8
  %77 = load %struct.grid** %g.addr, align 8
  %subdiv_level = getelementptr inbounds %struct.grid* %77, i32 0, i32 9
  %78 = load i64* %subdiv_level, align 8
  %add77 = add nsw i64 %78, 1
  %79 = load %struct.grid** %ng, align 8
  %subdiv_level78 = getelementptr inbounds %struct.grid* %79, i32 0, i32 9
  store i64 %add77, i64* %subdiv_level78, align 8
  %80 = load %struct.grid** @gridlist, align 8
  %81 = load %struct.grid** %ng, align 8
  %next = getelementptr inbounds %struct.grid* %81, i32 0, i32 11
  store %struct.grid* %80, %struct.grid** %next, align 8
  %82 = load %struct.grid** %ng, align 8
  store %struct.grid* %82, %struct.grid** @gridlist, align 8
  %83 = load %struct.grid** %ng, align 8
  %call79 = call %struct.btnode* @init_bintree(%struct.grid* %83)
  store %struct.btnode* %call79, %struct.btnode** %bintree, align 8
  %84 = load %struct.btnode** %bintree, align 8
  %85 = load %struct.grid** %ng, align 8
  call void @create_bintree(%struct.btnode* %84, %struct.grid* %85)
  store i64 0, i64* %index1D, align 8
  %86 = load i64* @hu_gridsize, align 8
  store i64 %86, i64* %n, align 8
  store i64 0, i64* %k, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc.113, %entry
  %87 = load i64* %k, align 8
  %88 = load i64* %n, align 8
  %cmp = icmp slt i64 %87, %88
  br i1 %cmp, label %for.body, label %for.end.115

for.body:                                         ; preds = %for.cond
  store i64 0, i64* %j, align 8
  br label %for.cond.81

for.cond.81:                                      ; preds = %for.inc.110, %for.body
  %89 = load i64* %j, align 8
  %90 = load i64* %n, align 8
  %cmp82 = icmp slt i64 %89, %90
  br i1 %cmp82, label %for.body.84, label %for.end.112

for.body.84:                                      ; preds = %for.cond.81
  store i64 0, i64* %i, align 8
  br label %for.cond.85

for.cond.85:                                      ; preds = %for.inc, %for.body.84
  %91 = load i64* %i, align 8
  %92 = load i64* %n, align 8
  %cmp86 = icmp slt i64 %91, %92
  br i1 %cmp86, label %for.body.88, label %for.end

for.body.88:                                      ; preds = %for.cond.85
  %93 = load %struct.btnode** %bintree, align 8
  %94 = load i64* %i, align 8
  %call89 = call %struct.element** @bintree_lookup(%struct.btnode* %93, i64 %94, i64 undef, i64 undef, %struct.grid* undef, i64* %nprims)
  store %struct.element** %call89, %struct.element*** %pepa, align 8
  %95 = load %struct.element*** %pepa, align 8
  %cmp90 = icmp ne %struct.element** %95, null
  br i1 %cmp90, label %if.then, label %if.else.105

if.then:                                          ; preds = %for.body.88
  %96 = load i64* %index1D, align 8
  %97 = load %struct.grid** %ng, align 8
  call void @mark_nonempty(i64 %96, %struct.grid* %97)
  %call93 = call i8* @ObjectMalloc(i64 1, i64 1)
  %98 = bitcast i8* %call93 to %struct.voxel*
  store %struct.voxel* %98, %struct.voxel** %nv, align 8
  %99 = load i64* %index1D, align 8
  %100 = load %struct.voxel** %nv, align 8
  %id94 = getelementptr inbounds %struct.voxel* %100, i32 0, i32 0
  store i64 %99, i64* %id94, align 8
  %101 = load %struct.voxel** %nv, align 8
  %celltype = getelementptr inbounds %struct.voxel* %101, i32 0, i32 2
  store i8 2, i8* %celltype, align 1
  %102 = load %struct.element*** %pepa, align 8
  %103 = bitcast %struct.element** %102 to i8*
  %104 = load %struct.voxel** %nv, align 8
  %cell95 = getelementptr inbounds %struct.voxel* %104, i32 0, i32 1
  store i8* %103, i8** %cell95, align 8
  %105 = load i64* %nprims, align 8
  %106 = load %struct.voxel** %nv, align 8
  %numelements = getelementptr inbounds %struct.voxel* %106, i32 0, i32 3
  store i64 %105, i64* %numelements, align 8
  %107 = load i64* %nprims, align 8
  %108 = load i64* @hu_max_prims_cell, align 8
  %cmp96 = icmp sgt i64 %107, %108
  br i1 %cmp96, label %land.lhs.true, label %if.else

land.lhs.true:                                    ; preds = %if.then
  %109 = load %struct.grid** %ng, align 8
  %subdiv_level98 = getelementptr inbounds %struct.grid* %109, i32 0, i32 9
  %110 = load i64* %subdiv_level98, align 8
  %111 = load i64* @hu_max_subdiv_level, align 8
  %cmp99 = icmp slt i64 %110, %111
  br i1 %cmp99, label %if.then.101, label %if.else

if.then.101:                                      ; preds = %land.lhs.true
  %112 = load %struct.voxel** %nv, align 8
  %113 = load %struct.grid** %ng, align 8
  %114 = load i64* %nprims, align 8
  %call102 = call %struct.grid* @create_grid(%struct.voxel* %112, %struct.grid* %113, i64 %114)
  br label %if.end

if.else:                                          ; preds = %land.lhs.true, %if.then
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then.101
  %115 = load %struct.voxel** %nv, align 8
  %116 = load %struct.grid** %ng, align 8
  call void @insert_in_hashtable(%struct.voxel* %115, %struct.grid* %116)
  br label %if.end.107

if.else.105:                                      ; preds = %for.body.88
  %117 = load i64* %index1D, align 8
  %118 = load %struct.grid** %ng, align 8
  call void @mark_empty(i64 %117, %struct.grid* %118)
  br label %if.end.107

if.end.107:                                       ; preds = %if.else.105, %if.end
  %119 = load i64* %index1D, align 8
  %inc108 = add nsw i64 %119, 1
  store i64 %inc108, i64* %index1D, align 8
  br label %for.inc

for.inc:                                          ; preds = %if.end.107
  %120 = load i64* %i, align 8
  %inc109 = add nsw i64 %120, 1
  store i64 %inc109, i64* %i, align 8
  br label %for.cond.85

for.end:                                          ; preds = %for.cond.85
  br label %for.inc.110

for.inc.110:                                      ; preds = %for.end
  %121 = load i64* %j, align 8
  %inc111 = add nsw i64 %121, 1
  store i64 %inc111, i64* %j, align 8
  br label %for.cond.81

for.end.112:                                      ; preds = %for.cond.81
  br label %for.inc.113

for.inc.113:                                      ; preds = %for.end.112
  %122 = load i64* %k, align 8
  %inc114 = add nsw i64 %122, 1
  store i64 %inc114, i64* %k, align 8
  br label %for.cond

for.end.115:                                      ; preds = %for.cond
  %123 = load %struct.grid** %ng, align 8
  %124 = bitcast %struct.grid* %123 to i8*
  %125 = load %struct.voxel** %v.addr, align 8
  %cell116 = getelementptr inbounds %struct.voxel* %125, i32 0, i32 1
  store i8* %124, i8** %cell116, align 8
  %126 = load %struct.voxel** %v.addr, align 8
  %numelements117 = getelementptr inbounds %struct.voxel* %126, i32 0, i32 3
  store i64 -1, i64* %numelements117, align 8
  %127 = load %struct.voxel** %v.addr, align 8
  %celltype118 = getelementptr inbounds %struct.voxel* %127, i32 0, i32 2
  store i8 3, i8* %celltype118, align 1
  ret %struct.grid* undef
}

; Function Attrs: nounwind uwtable
define internal void @PrintEnv() {
entry:
  %i = alloca i64, align 8
  %lp = alloca %struct.light*, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br label %for.end

for.body:                                         ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %sw.epilog

sw.bb:                                            ; No predecessors!
  br label %sw.epilog

sw.bb.23:                                         ; No predecessors!
  br label %sw.epilog

sw.epilog:                                        ; preds = %for.end, %sw.bb.23, %sw.bb
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %sw.epilog, %if.then
  br label %if.end.55

if.then.53:                                       ; No predecessors!
  br label %if.end.55

if.end.55:                                        ; preds = %if.end, %if.then.53
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @InitEnv() {
entry:
  store i64 100, i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 5), align 8
  store i64 100, i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 6), align 8
  store i64 10000, i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 7), align 8
  store i64 5, i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 0), align 8
  store i64 0, i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 1), align 8
  store double 2.000000e-02, double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 4), align 8
  store i64 8, i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 2), align 8
  store i64 8, i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 3), align 8
  store double 1.000000e-03, double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 8), align 8
  store double 1.645000e+02, double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 9), align 8
  store double 1.900000e+02, double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 10), align 8
  store double 1.900000e+02, double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 11), align 8
  %0 = load double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 10), align 8
  %mul = fmul double %0, 5.000000e-01
  store double %mul, double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 12), align 8
  %1 = load double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 11), align 8
  %mul1 = fmul double %1, 5.000000e-01
  store double %mul1, double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 13), align 8
  %2 = load double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 10), align 8
  %3 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 5), align 8
  %conv = sitofp i64 %3 to double
  %div = fdiv double %2, %conv
  store double %div, double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 14), align 8
  %4 = load double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 11), align 8
  %5 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 6), align 8
  %conv2 = sitofp i64 %5 to double
  %div3 = fdiv double %4, %conv2
  store double %div3, double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 15), align 8
  call void @MatrixIdentity([4 x double]* getelementptr inbounds (%struct.view* @View, i32 0, i32 2, i32 0))
  call void @MatrixIdentity([4 x double]* getelementptr inbounds (%struct.view* @View, i32 0, i32 4, i32 0))
  store i64 1, i64* @ModelNorm, align 8
  store i64 0, i64* @TraversalType, align 8
  %call = call i8* @GlobalMalloc(i64 72, i8* getelementptr inbounds ([6 x i8]* @.str.80, i32 0, i32 0))
  %6 = bitcast i8* %call to %struct.light*
  store %struct.light* %6, %struct.light** @lights, align 8
  store i64 25, i64* @bundlex, align 8
  store i64 25, i64* @bundley, align 8
  store i64 2, i64* @blockx, align 8
  store i64 2, i64* @blocky, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @InitLights() {
entry:
  store i64 1, i64* @nlights, align 8
  %0 = load %struct.light** @lights, align 8
  %pos = getelementptr inbounds %struct.light* %0, i32 0, i32 0
  %arrayidx = getelementptr inbounds [4 x double]* %pos, i32 0, i64 0
  store double 0.000000e+00, double* %arrayidx, align 8
  %1 = load %struct.light** @lights, align 8
  %pos1 = getelementptr inbounds %struct.light* %1, i32 0, i32 0
  %arrayidx2 = getelementptr inbounds [4 x double]* %pos1, i32 0, i64 1
  store double 0.000000e+00, double* %arrayidx2, align 8
  %2 = load %struct.light** @lights, align 8
  %pos3 = getelementptr inbounds %struct.light* %2, i32 0, i32 0
  %arrayidx4 = getelementptr inbounds [4 x double]* %pos3, i32 0, i64 2
  store double -2.000000e+03, double* %arrayidx4, align 8
  %3 = load %struct.light** @lights, align 8
  %pos5 = getelementptr inbounds %struct.light* %3, i32 0, i32 0
  %arrayidx6 = getelementptr inbounds [4 x double]* %pos5, i32 0, i64 3
  store double 1.000000e+00, double* %arrayidx6, align 8
  %4 = load %struct.light** @lights, align 8
  %col = getelementptr inbounds %struct.light* %4, i32 0, i32 1
  %arrayidx7 = getelementptr inbounds [3 x double]* %col, i32 0, i64 0
  store double 1.000000e+00, double* %arrayidx7, align 8
  %5 = load %struct.light** @lights, align 8
  %col8 = getelementptr inbounds %struct.light* %5, i32 0, i32 1
  %arrayidx9 = getelementptr inbounds [3 x double]* %col8, i32 0, i64 1
  store double 1.000000e+00, double* %arrayidx9, align 8
  %6 = load %struct.light** @lights, align 8
  %col10 = getelementptr inbounds %struct.light* %6, i32 0, i32 1
  %arrayidx11 = getelementptr inbounds [3 x double]* %col10, i32 0, i64 2
  store double 1.000000e+00, double* %arrayidx11, align 8
  %7 = load %struct.light** @lights, align 8
  %shadow = getelementptr inbounds %struct.light* %7, i32 0, i32 2
  store i64 1, i64* %shadow, align 8
  %8 = load %struct.light** @lights, align 8
  %next = getelementptr inbounds %struct.light* %8, i32 0, i32 3
  store %struct.light* null, %struct.light** %next, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @InitDisplay() {
entry:
  %aspect = alloca double, align 8
  %theta = alloca double, align 8
  %0 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 5), align 8
  %conv = sitofp i64 %0 to double
  %1 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 6), align 8
  %conv1 = sitofp i64 %1 to double
  %div = fdiv double %conv, %conv1
  store double %div, double* %aspect, align 8
  %2 = load double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 11), align 8
  %3 = load double* %aspect, align 8
  %mul3 = fmul double %2, %3
  store double %mul3, double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 10), align 8
  %4 = load double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 11), align 8
  %mul4 = fmul double 5.000000e-01, %4
  %call = call double @tan(double undef)
  %div5 = fdiv double %mul4, %call
  store double %div5, double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 9), align 8
  %5 = load double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 10), align 8
  %mul6 = fmul double %5, 5.000000e-01
  store double %mul6, double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 12), align 8
  %6 = load double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 11), align 8
  %mul7 = fmul double %6, 5.000000e-01
  store double %mul7, double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 13), align 8
  %7 = load double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 10), align 8
  %8 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 5), align 8
  %conv8 = sitofp i64 %8 to double
  %div9 = fdiv double %7, %conv8
  store double %div9, double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 14), align 8
  %9 = load double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 11), align 8
  %10 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 6), align 8
  %conv10 = sitofp i64 %10 to double
  %div11 = fdiv double %9, %conv10
  store double %div11, double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 15), align 8
  ret void
}

; Function Attrs: nounwind
declare double @tan(double)

; Function Attrs: nounwind uwtable
define internal i64 @VerifyColorRange(double* %c) {
entry:
  %retval = alloca i64, align 8
  %c.addr = alloca double*, align 8
  store double* %c, double** %c.addr, align 8
  %0 = load double** %c.addr, align 8
  %arrayidx = getelementptr inbounds double* %0, i64 0
  %1 = load double* %arrayidx, align 8
  %cmp = fcmp olt double %1, 0.000000e+00
  br i1 %cmp, label %if.then, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %entry
  %2 = load double** %c.addr, align 8
  %arrayidx1 = getelementptr inbounds double* %2, i64 0
  %3 = load double* %arrayidx1, align 8
  %cmp2 = fcmp ogt double %3, 1.000000e+00
  br i1 %cmp2, label %if.then, label %lor.lhs.false.3

lor.lhs.false.3:                                  ; preds = %lor.lhs.false
  %4 = load double** %c.addr, align 8
  %arrayidx4 = getelementptr inbounds double* %4, i64 1
  %5 = load double* %arrayidx4, align 8
  %cmp5 = fcmp olt double %5, 0.000000e+00
  br i1 %cmp5, label %if.then, label %lor.lhs.false.6

lor.lhs.false.6:                                  ; preds = %lor.lhs.false.3
  %6 = load double** %c.addr, align 8
  %arrayidx7 = getelementptr inbounds double* %6, i64 1
  %7 = load double* %arrayidx7, align 8
  %cmp8 = fcmp ogt double %7, 1.000000e+00
  br i1 %cmp8, label %if.then, label %lor.lhs.false.9

lor.lhs.false.9:                                  ; preds = %lor.lhs.false.6
  %8 = load double** %c.addr, align 8
  %arrayidx10 = getelementptr inbounds double* %8, i64 2
  %9 = load double* %arrayidx10, align 8
  %cmp11 = fcmp olt double %9, 0.000000e+00
  br i1 %cmp11, label %if.then, label %lor.lhs.false.12

lor.lhs.false.12:                                 ; preds = %lor.lhs.false.9
  %10 = load double** %c.addr, align 8
  %arrayidx13 = getelementptr inbounds double* %10, i64 2
  %11 = load double* %arrayidx13, align 8
  %cmp14 = fcmp ogt double %11, 1.000000e+00
  br i1 %cmp14, label %if.then, label %if.else

if.then:                                          ; preds = %lor.lhs.false.12, %lor.lhs.false.9, %lor.lhs.false.6, %lor.lhs.false.3, %lor.lhs.false, %entry
  store i64 0, i64* %retval
  br label %return

if.else:                                          ; preds = %lor.lhs.false.12
  store i64 1, i64* %retval
  br label %return

return:                                           ; preds = %if.else, %if.then
  %12 = load i64* %retval
  ret i64 %12
}

; Function Attrs: nounwind uwtable
define internal void @TransformLights([4 x double]* %m) {
entry:
  %m.addr = alloca [4 x double]*, align 8
  %i = alloca i64, align 8
  %lp = alloca %struct.light*, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br label %for.end

for.body:                                         ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @ViewRotate([4 x double]* %M, double %x, double %y, double %z) {
entry:
  %M.addr = alloca [4 x double]*, align 8
  %x.addr = alloca double, align 8
  %y.addr = alloca double, align 8
  %z.addr = alloca double, align 8
  %r = alloca double, align 8
  %rx = alloca double, align 8
  store [4 x double]* %M, [4 x double]** %M.addr, align 8
  store double %x, double* %x.addr, align 8
  store double %y, double* %y.addr, align 8
  store double %z, double* %z.addr, align 8
  %0 = load double* %x.addr, align 8
  %1 = load double* %x.addr, align 8
  %mul = fmul double %0, %1
  %2 = load double* %z.addr, align 8
  %3 = load double* %z.addr, align 8
  %mul1 = fmul double %2, %3
  %add = fadd double %mul, %mul1
  %call = call double @sqrt(double %add)
  store double %call, double* %rx, align 8
  %4 = load double* %rx, align 8
  %cmp = fcmp ogt double %4, 0.000000e+00
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  %5 = load double* %rx, align 8
  br label %cond.end

cond.false:                                       ; preds = %entry
  %6 = load double* %rx, align 8
  %sub = fsub double -0.000000e+00, %6
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi double [ %5, %cond.true ], [ %sub, %cond.false ]
  %cmp2 = fcmp olt double %cond, 1.000000e-07
  br i1 %cmp2, label %if.then, label %if.end

if.then:                                          ; preds = %cond.end
  %7 = load [4 x double]** %M.addr, align 8
  call void @MatrixIdentity([4 x double]* %7)
  %8 = load [4 x double]** %M.addr, align 8
  call void @Rotate(i64 1, [4 x double]* %8, double undef)
  br label %return

if.end:                                           ; preds = %cond.end
  %9 = load double* %x.addr, align 8
  %10 = load double* %x.addr, align 8
  %mul6 = fmul double %9, %10
  %11 = load double* %y.addr, align 8
  %12 = load double* %y.addr, align 8
  %mul7 = fmul double %11, %12
  %add8 = fadd double %mul6, %mul7
  %13 = load double* %z.addr, align 8
  %14 = load double* %z.addr, align 8
  %mul9 = fmul double %13, %14
  %add10 = fadd double %add8, %mul9
  %call11 = call double @sqrt(double %add10)
  store double %call11, double* %r, align 8
  %15 = load double* %z.addr, align 8
  %16 = load double* %rx, align 8
  %div = fdiv double %15, %16
  %17 = load [4 x double]** %M.addr, align 8
  %arrayidx = getelementptr inbounds [4 x double]* %17, i64 0
  %arrayidx12 = getelementptr inbounds [4 x double]* %arrayidx, i32 0, i64 0
  store double %div, double* %arrayidx12, align 8
  %18 = load double* %x.addr, align 8
  %sub13 = fsub double -0.000000e+00, %18
  %19 = load double* %y.addr, align 8
  %mul14 = fmul double %sub13, %19
  %20 = load double* %r, align 8
  %21 = load double* %rx, align 8
  %mul15 = fmul double %20, %21
  %div16 = fdiv double %mul14, %mul15
  %22 = load [4 x double]** %M.addr, align 8
  %arrayidx17 = getelementptr inbounds [4 x double]* %22, i64 0
  %arrayidx18 = getelementptr inbounds [4 x double]* %arrayidx17, i32 0, i64 1
  store double %div16, double* %arrayidx18, align 8
  %23 = load double* %x.addr, align 8
  %24 = load double* %r, align 8
  %div19 = fdiv double %23, %24
  %25 = load [4 x double]** %M.addr, align 8
  %arrayidx20 = getelementptr inbounds [4 x double]* %25, i64 0
  %arrayidx21 = getelementptr inbounds [4 x double]* %arrayidx20, i32 0, i64 2
  store double %div19, double* %arrayidx21, align 8
  %26 = load [4 x double]** %M.addr, align 8
  %arrayidx22 = getelementptr inbounds [4 x double]* %26, i64 0
  %arrayidx23 = getelementptr inbounds [4 x double]* %arrayidx22, i32 0, i64 3
  store double 0.000000e+00, double* %arrayidx23, align 8
  %27 = load [4 x double]** %M.addr, align 8
  %arrayidx24 = getelementptr inbounds [4 x double]* %27, i64 1
  %arrayidx25 = getelementptr inbounds [4 x double]* %arrayidx24, i32 0, i64 0
  store double 0.000000e+00, double* %arrayidx25, align 8
  %28 = load double* %rx, align 8
  %29 = load double* %r, align 8
  %div26 = fdiv double %28, %29
  %30 = load [4 x double]** %M.addr, align 8
  %arrayidx27 = getelementptr inbounds [4 x double]* %30, i64 1
  %arrayidx28 = getelementptr inbounds [4 x double]* %arrayidx27, i32 0, i64 1
  store double %div26, double* %arrayidx28, align 8
  %31 = load double* %y.addr, align 8
  %32 = load double* %r, align 8
  %div29 = fdiv double %31, %32
  %33 = load [4 x double]** %M.addr, align 8
  %arrayidx30 = getelementptr inbounds [4 x double]* %33, i64 1
  %arrayidx31 = getelementptr inbounds [4 x double]* %arrayidx30, i32 0, i64 2
  store double %div29, double* %arrayidx31, align 8
  %34 = load [4 x double]** %M.addr, align 8
  %arrayidx32 = getelementptr inbounds [4 x double]* %34, i64 1
  %arrayidx33 = getelementptr inbounds [4 x double]* %arrayidx32, i32 0, i64 3
  store double 0.000000e+00, double* %arrayidx33, align 8
  %35 = load double* %y.addr, align 8
  %sub38 = fsub double -0.000000e+00, %35
  %36 = load double* %z.addr, align 8
  %mul39 = fmul double %sub38, %36
  %37 = load double* %r, align 8
  %38 = load double* %rx, align 8
  %mul40 = fmul double %37, %38
  %div41 = fdiv double %mul39, %mul40
  %39 = load [4 x double]** %M.addr, align 8
  %arrayidx42 = getelementptr inbounds [4 x double]* %39, i64 2
  %arrayidx43 = getelementptr inbounds [4 x double]* %arrayidx42, i32 0, i64 1
  store double %div41, double* %arrayidx43, align 8
  %40 = load [4 x double]** %M.addr, align 8
  %arrayidx55 = getelementptr inbounds [4 x double]* %40, i64 3
  %arrayidx56 = getelementptr inbounds [4 x double]* %arrayidx55, i32 0, i64 3
  store double 1.000000e+00, double* %arrayidx56, align 8
  br label %return

return:                                           ; preds = %if.end, %if.then
  ret void
}

; Function Attrs: nounwind
declare double @sqrt(double)

; Function Attrs: nounwind uwtable
define internal void @CreateViewMatrix() {
entry:
  %T = alloca [4 x [4 x double]], align 16
  %R = alloca [4 x [4 x double]], align 16
  %arraydecay = getelementptr inbounds [4 x [4 x double]]* %T, i32 0, i32 0
  %0 = load double* getelementptr inbounds (%struct.view* @View, i32 0, i32 0, i64 2), align 8
  %sub2 = fsub double -0.000000e+00, %0
  call void @Translate([4 x double]* %arraydecay, double undef, double undef, double %sub2)
  %arraydecay3 = getelementptr inbounds [4 x [4 x double]]* %T, i32 0, i32 0
  call void @MatrixMult([4 x double]* getelementptr inbounds (%struct.view* @View, i32 0, i32 2, i32 0), [4 x double]* getelementptr inbounds (%struct.view* @View, i32 0, i32 2, i32 0), [4 x double]* %arraydecay3)
  %arraydecay4 = getelementptr inbounds [4 x [4 x double]]* %R, i32 0, i32 0
  %1 = load double* getelementptr inbounds (%struct.view* @View, i32 0, i32 1, i64 0), align 8
  %2 = load double* getelementptr inbounds (%struct.view* @View, i32 0, i32 0, i64 0), align 8
  %sub5 = fsub double %1, %2
  %3 = load double* getelementptr inbounds (%struct.view* @View, i32 0, i32 1, i64 1), align 8
  %4 = load double* getelementptr inbounds (%struct.view* @View, i32 0, i32 0, i64 1), align 8
  %sub6 = fsub double %3, %4
  %5 = load double* getelementptr inbounds (%struct.view* @View, i32 0, i32 1, i64 2), align 8
  %6 = load double* getelementptr inbounds (%struct.view* @View, i32 0, i32 0, i64 2), align 8
  %sub7 = fsub double %5, %6
  call void @ViewRotate([4 x double]* %arraydecay4, double %sub5, double %sub6, double %sub7)
  %arraydecay8 = getelementptr inbounds [4 x [4 x double]]* %R, i32 0, i32 0
  call void @MatrixMult([4 x double]* getelementptr inbounds (%struct.view* @View, i32 0, i32 2, i32 0), [4 x double]* getelementptr inbounds (%struct.view* @View, i32 0, i32 2, i32 0), [4 x double]* %arraydecay8)
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @TransformViewRay(double* %tray) {
entry:
  %tray.addr = alloca double*, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @NormalizeEnv([4 x double]* %normMat) {
entry:
  %normMat.addr = alloca [4 x double]*, align 8
  %tmp = alloca [4 x double], align 16
  ret void
}

; Function Attrs: nounwind uwtable
define internal signext i8 @LookupCommand(i8* %s) {
entry:
  %retval = alloca i8, align 1
  %s.addr = alloca i8*, align 8
  %i = alloca i64, align 8
  store i8* %s, i8** %s.addr, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i64* %i, align 8
  %cmp = icmp ult i64 %0, 42
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %1 = load i8** %s.addr, align 8
  %2 = load i64* %i, align 8
  %arrayidx = getelementptr inbounds [42 x %struct.CTE]* @cmdtab, i32 0, i64 %2
  %command = getelementptr inbounds %struct.CTE* %arrayidx, i32 0, i32 0
  %3 = load i8** %command, align 8
  %call = call i32 @strcmp(i8* %1, i8* %3)
  %cmp1 = icmp eq i32 %call, 0
  br i1 %cmp1, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  %4 = load i64* %i, align 8
  %arrayidx2 = getelementptr inbounds [42 x %struct.CTE]* @cmdtab, i32 0, i64 %4
  %opcode = getelementptr inbounds %struct.CTE* %arrayidx2, i32 0, i32 1
  %5 = load i8* %opcode, align 1
  store i8 %5, i8* %retval
  br label %return

if.end:                                           ; preds = %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %6 = load i64* %i, align 8
  %inc = add nsw i64 %6, 1
  store i64 %inc, i64* %i, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i8 48, i8* %retval
  br label %return

return:                                           ; preds = %for.end, %if.then
  %7 = load i8* %retval
  ret i8 %7
}

declare i32 @strcmp(i8*, i8*)

; Function Attrs: nounwind uwtable
define internal void @ReadEnvFile(i8* %EnvFileName) {
entry:
  %EnvFileName.addr = alloca i8*, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %stat = alloca i64, align 8
  %dummy = alloca i64, align 8
  %opcode = alloca i8, align 1
  %command = alloca [30 x i8], align 16
  %opparam = alloca [30 x i8], align 16
  %dummy_char = alloca [60 x i8], align 16
  %datafile = alloca [10 x i8], align 1
  %lights_set = alloca i64, align 8
  %pf = alloca %struct._IO_FILE*, align 8
  %lptr = alloca %struct.light*, align 8
  %lastlight = alloca %struct.light*, align 8
  store i8* %EnvFileName, i8** %EnvFileName.addr, align 8
  %0 = load i8** %EnvFileName.addr, align 8
  %call = call %struct._IO_FILE* @fopen(i8* %0, i8* getelementptr inbounds ([2 x i8]* @.str.83, i32 0, i32 0))
  store %struct._IO_FILE* %call, %struct._IO_FILE** %pf, align 8
  %1 = load %struct._IO_FILE** %pf, align 8
  %tobool = icmp ne %struct._IO_FILE* %1, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  br label %UnifiedUnreachableBlock

if.end:                                           ; preds = %entry
  call void @InitEnv()
  store i64 0, i64* @nlights, align 8
  store i64 0, i64* %lights_set, align 8
  br label %while.cond

while.cond:                                       ; preds = %sw.epilog, %if.end
  %2 = load %struct._IO_FILE** %pf, align 8
  %arraydecay = getelementptr inbounds [30 x i8]* %command, i32 0, i32 0
  %call2 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %2, i8* getelementptr inbounds ([3 x i8]* @.str.85, i32 0, i32 0), i8* %arraydecay)
  %cmp = icmp ne i32 %call2, -1
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %arraydecay3 = getelementptr inbounds [30 x i8]* %command, i32 0, i32 0
  %call4 = call signext i8 @LookupCommand(i8* %arraydecay3)
  store i8 %call4, i8* %opcode, align 1
  %3 = load i8* %opcode, align 1
  %conv = sext i8 %3 to i32
  switch i32 %conv, label %sw.default [
    i32 97, label %sw.bb
    i32 98, label %sw.bb.12
    i32 99, label %sw.bb.20
    i32 100, label %sw.bb.32
    i32 120, label %sw.bb.47
    i32 106, label %sw.bb.59
    i32 103, label %sw.bb.75
    i32 104, label %sw.bb.93
    i32 107, label %sw.bb.109
    i32 102, label %sw.bb.125
    i32 101, label %sw.bb.133
    i32 108, label %sw.bb.175
    i32 109, label %sw.bb.195
    i32 110, label %sw.bb.211
    i32 105, label %sw.bb.228
    i32 119, label %sw.bb.254
    i32 113, label %sw.bb.280
    i32 115, label %sw.bb.288
    i32 51, label %sw.bb.296
    i32 52, label %sw.bb.304
    i32 53, label %sw.bb.312
    i32 54, label %sw.bb.321
    i32 55, label %sw.bb.336
    i32 56, label %sw.bb.351
    i32 64, label %sw.bb.359
    i32 35, label %sw.bb.367
    i32 36, label %sw.bb.375
    i32 42, label %sw.bb.386
    i32 43, label %sw.bb.394
    i32 37, label %sw.bb.402
  ]

sw.bb:                                            ; preds = %while.body
  %4 = load %struct._IO_FILE** %pf, align 8
  %call5 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %4, i8* getelementptr inbounds ([12 x i8]* @.str.86, i32 0, i32 0), double* getelementptr inbounds (%struct.view* @View, i32 0, i32 0, i64 0), double* getelementptr inbounds (%struct.view* @View, i32 0, i32 0, i64 1), double* getelementptr inbounds (%struct.view* @View, i32 0, i32 0, i64 2))
  %conv6 = sext i32 %call5 to i64
  store i64 %conv6, i64* %stat, align 8
  %5 = load i64* %stat, align 8
  %cmp7 = icmp ne i64 %5, 3
  br i1 %cmp7, label %if.then.9, label %if.end.11

if.then.9:                                        ; preds = %sw.bb
  br label %UnifiedUnreachableBlock

if.end.11:                                        ; preds = %sw.bb
  br label %sw.epilog

sw.bb.12:                                         ; preds = %while.body
  %6 = load %struct._IO_FILE** %pf, align 8
  %call13 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %6, i8* getelementptr inbounds ([12 x i8]* @.str.86, i32 0, i32 0), double* getelementptr inbounds (%struct.view* @View, i32 0, i32 1, i64 0), double* getelementptr inbounds (%struct.view* @View, i32 0, i32 1, i64 1), double* getelementptr inbounds (%struct.view* @View, i32 0, i32 1, i64 2))
  %conv14 = sext i32 %call13 to i64
  store i64 %conv14, i64* %stat, align 8
  %7 = load i64* %stat, align 8
  %cmp15 = icmp ne i64 %7, 3
  br i1 %cmp15, label %if.then.17, label %if.end.19

if.then.17:                                       ; preds = %sw.bb.12
  br label %UnifiedUnreachableBlock

if.end.19:                                        ; preds = %sw.bb.12
  br label %sw.epilog

sw.bb.20:                                         ; preds = %while.body
  %8 = load %struct._IO_FILE** %pf, align 8
  %call21 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %8, i8* getelementptr inbounds ([12 x i8]* @.str.86, i32 0, i32 0), double* getelementptr inbounds (%struct.view* @View, i32 0, i32 5, i64 0), double* getelementptr inbounds (%struct.view* @View, i32 0, i32 5, i64 1), double* getelementptr inbounds (%struct.view* @View, i32 0, i32 5, i64 2))
  %conv22 = sext i32 %call21 to i64
  store i64 %conv22, i64* %stat, align 8
  %9 = load i64* %stat, align 8
  %cmp23 = icmp ne i64 %9, 3
  br i1 %cmp23, label %if.then.25, label %if.end.27

if.then.25:                                       ; preds = %sw.bb.20
  br label %UnifiedUnreachableBlock

if.end.27:                                        ; preds = %sw.bb.20
  %call28 = call i64 @VerifyColorRange(double* getelementptr inbounds (%struct.view* @View, i32 0, i32 5, i32 0))
  %tobool29 = icmp ne i64 %call28, 0
  br i1 %tobool29, label %if.end.31, label %if.then.30

if.then.30:                                       ; preds = %if.end.27
  br label %UnifiedUnreachableBlock

if.end.31:                                        ; preds = %if.end.27
  br label %sw.epilog

sw.bb.32:                                         ; preds = %while.body
  %10 = load %struct._IO_FILE** %pf, align 8
  %call33 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %10, i8* getelementptr inbounds ([4 x i8]* @.str.90, i32 0, i32 0), double* getelementptr inbounds (%struct.view* @View, i32 0, i32 7))
  %conv34 = sext i32 %call33 to i64
  store i64 %conv34, i64* %stat, align 8
  %11 = load i64* %stat, align 8
  %cmp35 = icmp ne i64 %11, 1
  br i1 %cmp35, label %if.then.37, label %if.end.39

if.then.37:                                       ; preds = %sw.bb.32
  br label %UnifiedUnreachableBlock

if.end.39:                                        ; preds = %sw.bb.32
  %12 = load double* getelementptr inbounds (%struct.view* @View, i32 0, i32 7), align 8
  %cmp40 = fcmp olt double %12, 0.000000e+00
  br i1 %cmp40, label %if.then.44, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %if.end.39
  %13 = load double* getelementptr inbounds (%struct.view* @View, i32 0, i32 7), align 8
  %cmp42 = fcmp ogt double %13, 1.000000e+02
  br i1 %cmp42, label %if.then.44, label %if.end.46

if.then.44:                                       ; preds = %lor.lhs.false, %if.end.39
  br label %UnifiedUnreachableBlock

if.end.46:                                        ; preds = %lor.lhs.false
  br label %sw.epilog

sw.bb.47:                                         ; preds = %while.body
  %14 = load %struct._IO_FILE** %pf, align 8
  %call48 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %14, i8* getelementptr inbounds ([12 x i8]* @.str.86, i32 0, i32 0), double* getelementptr inbounds (%struct.view* @View, i32 0, i32 8, i64 0), double* getelementptr inbounds (%struct.view* @View, i32 0, i32 8, i64 1), double* getelementptr inbounds (%struct.view* @View, i32 0, i32 8, i64 2))
  %conv49 = sext i32 %call48 to i64
  store i64 %conv49, i64* %stat, align 8
  %15 = load i64* %stat, align 8
  %cmp50 = icmp ne i64 %15, 3
  br i1 %cmp50, label %if.then.52, label %if.end.54

if.then.52:                                       ; preds = %sw.bb.47
  br label %UnifiedUnreachableBlock

if.end.54:                                        ; preds = %sw.bb.47
  %call55 = call i64 @VerifyColorRange(double* getelementptr inbounds (%struct.view* @View, i32 0, i32 8, i32 0))
  %tobool56 = icmp ne i64 %call55, 0
  br i1 %tobool56, label %if.end.58, label %if.then.57

if.then.57:                                       ; preds = %if.end.54
  br label %UnifiedUnreachableBlock

if.end.58:                                        ; preds = %if.end.54
  br label %sw.epilog

sw.bb.59:                                         ; preds = %while.body
  %16 = load %struct._IO_FILE** %pf, align 8
  %call60 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %16, i8* getelementptr inbounds ([4 x i8]* @.str.94, i32 0, i32 0), i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 1))
  %conv61 = sext i32 %call60 to i64
  store i64 %conv61, i64* %stat, align 8
  %17 = load i64* %stat, align 8
  %cmp62 = icmp ne i64 %17, 1
  br i1 %cmp62, label %if.then.64, label %if.end.66

if.then.64:                                       ; preds = %sw.bb.59
  br label %UnifiedUnreachableBlock

if.end.66:                                        ; preds = %sw.bb.59
  %18 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 1), align 8
  %cmp67 = icmp slt i64 %18, 0
  br i1 %cmp67, label %if.then.72, label %lor.lhs.false.69

lor.lhs.false.69:                                 ; preds = %if.end.66
  %19 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 1), align 8
  %cmp70 = icmp sgt i64 %19, 3
  br i1 %cmp70, label %if.then.72, label %if.end.74

if.then.72:                                       ; preds = %lor.lhs.false.69, %if.end.66
  br label %UnifiedUnreachableBlock

if.end.74:                                        ; preds = %lor.lhs.false.69
  br label %sw.epilog

sw.bb.75:                                         ; preds = %while.body
  %20 = load %struct._IO_FILE** %pf, align 8
  %call76 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %20, i8* getelementptr inbounds ([4 x i8]* @.str.94, i32 0, i32 0), i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 0))
  %conv77 = sext i32 %call76 to i64
  store i64 %conv77, i64* %stat, align 8
  %21 = load i64* %stat, align 8
  %cmp80 = icmp ne i64 %21, 1
  br i1 %cmp80, label %if.then.82, label %if.end.84

if.then.82:                                       ; preds = %sw.bb.75
  br label %UnifiedUnreachableBlock

if.end.84:                                        ; preds = %sw.bb.75
  %22 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 0), align 8
  %cmp85 = icmp sgt i64 %22, 5
  br i1 %cmp85, label %if.then.90, label %lor.lhs.false.87

lor.lhs.false.87:                                 ; preds = %if.end.84
  %23 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 0), align 8
  %cmp88 = icmp slt i64 %23, 0
  br i1 %cmp88, label %if.then.90, label %if.end.92

if.then.90:                                       ; preds = %lor.lhs.false.87, %if.end.84
  br label %UnifiedUnreachableBlock

if.end.92:                                        ; preds = %lor.lhs.false.87
  br label %sw.epilog

sw.bb.93:                                         ; preds = %while.body
  %24 = load %struct._IO_FILE** %pf, align 8
  %call94 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %24, i8* getelementptr inbounds ([4 x i8]* @.str.90, i32 0, i32 0), double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 8))
  %conv95 = sext i32 %call94 to i64
  store i64 %conv95, i64* %stat, align 8
  %25 = load i64* %stat, align 8
  %cmp96 = icmp ne i64 %25, 1
  br i1 %cmp96, label %if.then.98, label %if.end.100

if.then.98:                                       ; preds = %sw.bb.93
  br label %UnifiedUnreachableBlock

if.end.100:                                       ; preds = %sw.bb.93
  %26 = load double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 8), align 8
  %cmp101 = fcmp olt double %26, 0.000000e+00
  br i1 %cmp101, label %if.then.106, label %lor.lhs.false.103

lor.lhs.false.103:                                ; preds = %if.end.100
  %27 = load double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 8), align 8
  %cmp104 = fcmp ogt double %27, 1.000000e+00
  br i1 %cmp104, label %if.then.106, label %if.end.108

if.then.106:                                      ; preds = %lor.lhs.false.103, %if.end.100
  br label %UnifiedUnreachableBlock

if.end.108:                                       ; preds = %lor.lhs.false.103
  br label %sw.epilog

sw.bb.109:                                        ; preds = %while.body
  %28 = load %struct._IO_FILE** %pf, align 8
  %call110 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %28, i8* getelementptr inbounds ([4 x i8]* @.str.90, i32 0, i32 0), double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 4))
  %conv111 = sext i32 %call110 to i64
  store i64 %conv111, i64* %stat, align 8
  %29 = load i64* %stat, align 8
  %cmp112 = icmp ne i64 %29, 1
  br i1 %cmp112, label %if.then.114, label %if.end.116

if.then.114:                                      ; preds = %sw.bb.109
  br label %UnifiedUnreachableBlock

if.end.116:                                       ; preds = %sw.bb.109
  %30 = load double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 4), align 8
  %cmp117 = fcmp olt double %30, 0.000000e+00
  br i1 %cmp117, label %if.then.122, label %lor.lhs.false.119

lor.lhs.false.119:                                ; preds = %if.end.116
  %31 = load double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 4), align 8
  %cmp120 = fcmp ogt double %31, 1.000000e+00
  br i1 %cmp120, label %if.then.122, label %if.end.124

if.then.122:                                      ; preds = %lor.lhs.false.119, %if.end.116
  br label %UnifiedUnreachableBlock

if.end.124:                                       ; preds = %lor.lhs.false.119
  br label %sw.epilog

sw.bb.125:                                        ; preds = %while.body
  %32 = load %struct._IO_FILE** %pf, align 8
  %call126 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %32, i8* getelementptr inbounds ([8 x i8]* @.str.104, i32 0, i32 0), i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 5), i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 6))
  %conv127 = sext i32 %call126 to i64
  store i64 %conv127, i64* %stat, align 8
  %33 = load i64* %stat, align 8
  %cmp128 = icmp ne i64 %33, 2
  br i1 %cmp128, label %if.then.130, label %if.end.132

if.then.130:                                      ; preds = %sw.bb.125
  br label %UnifiedUnreachableBlock

if.end.132:                                       ; preds = %sw.bb.125
  br label %sw.epilog

sw.bb.133:                                        ; preds = %while.body
  store i64 1, i64* %lights_set, align 8
  %34 = load i64* @nlights, align 8
  %cmp134 = icmp sgt i64 %34, 0
  br i1 %cmp134, label %if.then.136, label %if.else

if.then.136:                                      ; preds = %sw.bb.133
  %call137 = call i8* @GlobalMalloc(i64 72, i8* getelementptr inbounds ([6 x i8]* @.str.80, i32 0, i32 0))
  %35 = bitcast i8* %call137 to %struct.light*
  store %struct.light* %35, %struct.light** %lptr, align 8
  br label %if.end.138

if.else:                                          ; preds = %sw.bb.133
  %36 = load %struct.light** @lights, align 8
  store %struct.light* %36, %struct.light** %lptr, align 8
  br label %if.end.138

if.end.138:                                       ; preds = %if.else, %if.then.136
  %37 = load %struct._IO_FILE** %pf, align 8
  %38 = load %struct.light** %lptr, align 8
  %pos = getelementptr inbounds %struct.light* %38, i32 0, i32 0
  %arrayidx = getelementptr inbounds [4 x double]* %pos, i32 0, i64 0
  %39 = load %struct.light** %lptr, align 8
  %pos139 = getelementptr inbounds %struct.light* %39, i32 0, i32 0
  %arrayidx140 = getelementptr inbounds [4 x double]* %pos139, i32 0, i64 1
  %40 = load %struct.light** %lptr, align 8
  %pos141 = getelementptr inbounds %struct.light* %40, i32 0, i32 0
  %arrayidx142 = getelementptr inbounds [4 x double]* %pos141, i32 0, i64 2
  %41 = load %struct.light** %lptr, align 8
  %col = getelementptr inbounds %struct.light* %41, i32 0, i32 1
  %arrayidx143 = getelementptr inbounds [3 x double]* %col, i32 0, i64 0
  %42 = load %struct.light** %lptr, align 8
  %col144 = getelementptr inbounds %struct.light* %42, i32 0, i32 1
  %arrayidx145 = getelementptr inbounds [3 x double]* %col144, i32 0, i64 1
  %43 = load %struct.light** %lptr, align 8
  %col146 = getelementptr inbounds %struct.light* %43, i32 0, i32 1
  %arrayidx147 = getelementptr inbounds [3 x double]* %col146, i32 0, i64 2
  %call148 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %37, i8* getelementptr inbounds ([24 x i8]* @.str.106, i32 0, i32 0), double* %arrayidx, double* %arrayidx140, double* %arrayidx142, double* %arrayidx143, double* %arrayidx145, double* %arrayidx147)
  %conv149 = sext i32 %call148 to i64
  store i64 %conv149, i64* %stat, align 8
  %44 = load i64* %stat, align 8
  %cmp150 = icmp ne i64 %44, 6
  br i1 %cmp150, label %if.then.152, label %if.end.154

if.then.152:                                      ; preds = %if.end.138
  br label %UnifiedUnreachableBlock

if.end.154:                                       ; preds = %if.end.138
  %45 = load %struct.light** %lptr, align 8
  %col155 = getelementptr inbounds %struct.light* %45, i32 0, i32 1
  %arraydecay156 = getelementptr inbounds [3 x double]* %col155, i32 0, i32 0
  %call157 = call i64 @VerifyColorRange(double* %arraydecay156)
  %tobool158 = icmp ne i64 %call157, 0
  br i1 %tobool158, label %if.end.160, label %if.then.159

if.then.159:                                      ; preds = %if.end.154
  br label %UnifiedUnreachableBlock

if.end.160:                                       ; preds = %if.end.154
  %46 = load %struct.light** %lptr, align 8
  %pos161 = getelementptr inbounds %struct.light* %46, i32 0, i32 0
  %arrayidx162 = getelementptr inbounds [4 x double]* %pos161, i32 0, i64 3
  store double 1.000000e+00, double* %arrayidx162, align 8
  %47 = load %struct._IO_FILE** %pf, align 8
  %48 = load %struct.light** %lptr, align 8
  %shadow = getelementptr inbounds %struct.light* %48, i32 0, i32 2
  %call163 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %47, i8* getelementptr inbounds ([4 x i8]* @.str.94, i32 0, i32 0), i64* %shadow)
  %conv164 = sext i32 %call163 to i64
  store i64 %conv164, i64* %stat, align 8
  %49 = load i64* %stat, align 8
  %cmp165 = icmp ne i64 %49, 1
  br i1 %cmp165, label %if.then.167, label %if.end.169

if.then.167:                                      ; preds = %if.end.160
  br label %UnifiedUnreachableBlock

if.end.169:                                       ; preds = %if.end.160
  %50 = load %struct.light** %lptr, align 8
  %next = getelementptr inbounds %struct.light* %50, i32 0, i32 3
  store %struct.light* null, %struct.light** %next, align 8
  %51 = load i64* @nlights, align 8
  %cmp170 = icmp sgt i64 %51, 0
  br i1 %cmp170, label %if.then.172, label %if.end.174

if.then.172:                                      ; preds = %if.end.169
  %52 = load %struct.light** %lptr, align 8
  %53 = load %struct.light** %lastlight, align 8
  %next173 = getelementptr inbounds %struct.light* %53, i32 0, i32 3
  store %struct.light* %52, %struct.light** %next173, align 8
  br label %if.end.174

if.end.174:                                       ; preds = %if.then.172, %if.end.169
  %54 = load i64* @nlights, align 8
  %inc = add nsw i64 %54, 1
  store i64 %inc, i64* @nlights, align 8
  %55 = load %struct.light** %lptr, align 8
  store %struct.light* %55, %struct.light** %lastlight, align 8
  br label %sw.epilog

sw.bb.175:                                        ; preds = %while.body
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc.192, %sw.bb.175
  %56 = load i64* %i, align 8
  %cmp176 = icmp slt i64 %56, 4
  br i1 %cmp176, label %for.body, label %for.end.194

for.body:                                         ; preds = %for.cond
  store i64 0, i64* %j, align 8
  br label %for.cond.178

for.cond.178:                                     ; preds = %for.inc, %for.body
  %57 = load i64* %j, align 8
  %cmp179 = icmp slt i64 %57, 4
  br i1 %cmp179, label %for.body.181, label %for.end

for.body.181:                                     ; preds = %for.cond.178
  %58 = load %struct._IO_FILE** %pf, align 8
  %59 = load i64* %j, align 8
  %60 = load i64* %i, align 8
  %arrayidx182 = getelementptr inbounds [4 x [4 x double]]* getelementptr inbounds (%struct.view* @View, i32 0, i32 4), i32 0, i64 %60
  %arrayidx183 = getelementptr inbounds [4 x double]* %arrayidx182, i32 0, i64 %59
  %call184 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %58, i8* getelementptr inbounds ([4 x i8]* @.str.90, i32 0, i32 0), double* %arrayidx183)
  %conv185 = sext i32 %call184 to i64
  store i64 %conv185, i64* %stat, align 8
  %61 = load i64* %stat, align 8
  %cmp186 = icmp ne i64 %61, 1
  br i1 %cmp186, label %if.then.188, label %if.end.190

if.then.188:                                      ; preds = %for.body.181
  br label %UnifiedUnreachableBlock

if.end.190:                                       ; preds = %for.body.181
  br label %for.inc

for.inc:                                          ; preds = %if.end.190
  %62 = load i64* %j, align 8
  %inc191 = add nsw i64 %62, 1
  store i64 %inc191, i64* %j, align 8
  br label %for.cond.178

for.end:                                          ; preds = %for.cond.178
  br label %for.inc.192

for.inc.192:                                      ; preds = %for.end
  %63 = load i64* %i, align 8
  %inc193 = add nsw i64 %63, 1
  store i64 %inc193, i64* %i, align 8
  br label %for.cond

for.end.194:                                      ; preds = %for.cond
  br label %sw.epilog

sw.bb.195:                                        ; preds = %while.body
  %64 = load %struct._IO_FILE** %pf, align 8
  %arraydecay196 = getelementptr inbounds [30 x i8]* %opparam, i32 0, i32 0
  %call197 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %64, i8* getelementptr inbounds ([3 x i8]* @.str.85, i32 0, i32 0), i8* %arraydecay196)
  %conv198 = sext i32 %call197 to i64
  store i64 %conv198, i64* %stat, align 8
  %65 = load i64* %stat, align 8
  %cmp199 = icmp ne i64 %65, 1
  br i1 %cmp199, label %if.then.201, label %if.end.203

if.then.201:                                      ; preds = %sw.bb.195
  br label %UnifiedUnreachableBlock

if.end.203:                                       ; preds = %sw.bb.195
  %arraydecay204 = getelementptr inbounds [30 x i8]* %opparam, i32 0, i32 0
  %call205 = call i32 @strcmp(i8* %arraydecay204, i8* getelementptr inbounds ([3 x i8]* @.str.111, i32 0, i32 0))
  %cmp206 = icmp eq i32 %call205, 0
  br i1 %cmp206, label %if.then.208, label %if.else.209

if.then.208:                                      ; preds = %if.end.203
  store i64 1, i64* getelementptr inbounds (%struct.view* @View, i32 0, i32 9), align 8
  br label %if.end.210

if.else.209:                                      ; preds = %if.end.203
  store i64 0, i64* getelementptr inbounds (%struct.view* @View, i32 0, i32 9), align 8
  br label %if.end.210

if.end.210:                                       ; preds = %if.else.209, %if.then.208
  br label %sw.epilog

sw.bb.211:                                        ; preds = %while.body
  %66 = load %struct._IO_FILE** %pf, align 8
  %arraydecay212 = getelementptr inbounds [30 x i8]* %opparam, i32 0, i32 0
  %call213 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %66, i8* getelementptr inbounds ([3 x i8]* @.str.85, i32 0, i32 0), i8* %arraydecay212)
  %conv214 = sext i32 %call213 to i64
  store i64 %conv214, i64* %stat, align 8
  %67 = load i64* %stat, align 8
  %cmp215 = icmp ne i64 %67, 1
  br i1 %cmp215, label %if.then.217, label %if.end.220

if.then.217:                                      ; preds = %sw.bb.211
  br label %UnifiedUnreachableBlock

if.end.220:                                       ; preds = %sw.bb.211
  %arraydecay221 = getelementptr inbounds [30 x i8]* %opparam, i32 0, i32 0
  %call222 = call i32 @strcmp(i8* %arraydecay221, i8* getelementptr inbounds ([3 x i8]* @.str.111, i32 0, i32 0))
  %cmp223 = icmp eq i32 %call222, 0
  br i1 %cmp223, label %if.then.225, label %if.else.226

if.then.225:                                      ; preds = %if.end.220
  store i64 1, i64* getelementptr inbounds (%struct.view* @View, i32 0, i32 10), align 8
  br label %if.end.227

if.else.226:                                      ; preds = %if.end.220
  store i64 0, i64* getelementptr inbounds (%struct.view* @View, i32 0, i32 10), align 8
  br label %if.end.227

if.end.227:                                       ; preds = %if.else.226, %if.then.225
  br label %sw.epilog

sw.bb.228:                                        ; preds = %while.body
  %68 = load %struct._IO_FILE** %pf, align 8
  %arraydecay229 = getelementptr inbounds [30 x i8]* %opparam, i32 0, i32 0
  %call230 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %68, i8* getelementptr inbounds ([3 x i8]* @.str.85, i32 0, i32 0), i8* %arraydecay229)
  %conv231 = sext i32 %call230 to i64
  store i64 %conv231, i64* %stat, align 8
  %69 = load i64* %stat, align 8
  %cmp232 = icmp ne i64 %69, 1
  br i1 %cmp232, label %if.then.234, label %if.end.237

if.then.234:                                      ; preds = %sw.bb.228
  br label %UnifiedUnreachableBlock

if.end.237:                                       ; preds = %sw.bb.228
  %arraydecay238 = getelementptr inbounds [30 x i8]* %opparam, i32 0, i32 0
  %call239 = call i32 @strcmp(i8* %arraydecay238, i8* getelementptr inbounds ([12 x i8]* @.str.114, i32 0, i32 0))
  %cmp240 = icmp eq i32 %call239, 0
  br i1 %cmp240, label %if.then.242, label %if.else.243

if.then.242:                                      ; preds = %if.end.237
  store i64 0, i64* getelementptr inbounds (%struct.view* @View, i32 0, i32 6), align 8
  br label %if.end.253

if.else.243:                                      ; preds = %if.end.237
  %arraydecay244 = getelementptr inbounds [30 x i8]* %opparam, i32 0, i32 0
  %call245 = call i32 @strcmp(i8* %arraydecay244, i8* getelementptr inbounds ([13 x i8]* @.str.115, i32 0, i32 0))
  %cmp246 = icmp eq i32 %call245, 0
  br i1 %cmp246, label %if.then.248, label %if.else.249

if.then.248:                                      ; preds = %if.else.243
  store i64 1, i64* getelementptr inbounds (%struct.view* @View, i32 0, i32 6), align 8
  br label %if.end.252

if.else.249:                                      ; preds = %if.else.243
  br label %UnifiedUnreachableBlock

if.end.252:                                       ; preds = %if.then.248
  br label %if.end.253

if.end.253:                                       ; preds = %if.end.252, %if.then.242
  br label %sw.epilog

sw.bb.254:                                        ; preds = %while.body
  %70 = load %struct._IO_FILE** %pf, align 8
  %arraydecay255 = getelementptr inbounds [30 x i8]* %opparam, i32 0, i32 0
  %call256 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %70, i8* getelementptr inbounds ([3 x i8]* @.str.85, i32 0, i32 0), i8* %arraydecay255)
  %conv257 = sext i32 %call256 to i64
  store i64 %conv257, i64* %stat, align 8
  %71 = load i64* %stat, align 8
  %cmp258 = icmp ne i64 %71, 1
  br i1 %cmp258, label %if.then.260, label %if.end.263

if.then.260:                                      ; preds = %sw.bb.254
  br label %UnifiedUnreachableBlock

if.end.263:                                       ; preds = %sw.bb.254
  %arraydecay264 = getelementptr inbounds [30 x i8]* %opparam, i32 0, i32 0
  %call265 = call i32 @strcmp(i8* %arraydecay264, i8* getelementptr inbounds ([5 x i8]* @.str.118, i32 0, i32 0))
  %cmp266 = icmp eq i32 %call265, 0
  br i1 %cmp266, label %if.then.268, label %if.else.269

if.then.268:                                      ; preds = %if.end.263
  store i64 0, i64* @TraversalType, align 8
  br label %if.end.279

if.else.269:                                      ; preds = %if.end.263
  %arraydecay270 = getelementptr inbounds [30 x i8]* %opparam, i32 0, i32 0
  %call271 = call i32 @strcmp(i8* %arraydecay270, i8* getelementptr inbounds ([9 x i8]* @.str.119, i32 0, i32 0))
  %cmp272 = icmp eq i32 %call271, 0
  br i1 %cmp272, label %if.then.274, label %if.else.275

if.then.274:                                      ; preds = %if.else.269
  store i64 1, i64* @TraversalType, align 8
  br label %if.end.278

if.else.275:                                      ; preds = %if.else.269
  br label %UnifiedUnreachableBlock

if.end.278:                                       ; preds = %if.then.274
  br label %if.end.279

if.end.279:                                       ; preds = %if.end.278, %if.then.268
  br label %sw.epilog

sw.bb.280:                                        ; preds = %while.body
  %72 = load %struct._IO_FILE** %pf, align 8
  %call281 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %72, i8* getelementptr inbounds ([4 x i8]* @.str.121, i32 0, i32 0), i8* getelementptr inbounds ([80 x i8]* @GeoFileName, i32 0, i32 0))
  %conv282 = sext i32 %call281 to i64
  store i64 %conv282, i64* %stat, align 8
  %73 = load i64* %stat, align 8
  %cmp283 = icmp ne i64 %73, 1
  br i1 %cmp283, label %if.then.285, label %if.end.287

if.then.285:                                      ; preds = %sw.bb.280
  br label %UnifiedUnreachableBlock

if.end.287:                                       ; preds = %sw.bb.280
  br label %sw.epilog

sw.bb.288:                                        ; preds = %while.body
  %74 = load %struct._IO_FILE** %pf, align 8
  %call289 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %74, i8* getelementptr inbounds ([4 x i8]* @.str.121, i32 0, i32 0), i8* getelementptr inbounds ([80 x i8]* @PicFileName, i32 0, i32 0))
  %conv290 = sext i32 %call289 to i64
  store i64 %conv290, i64* %stat, align 8
  %75 = load i64* %stat, align 8
  %cmp291 = icmp ne i64 %75, 1
  br i1 %cmp291, label %if.then.293, label %if.end.295

if.then.293:                                      ; preds = %sw.bb.288
  br label %UnifiedUnreachableBlock

if.end.295:                                       ; preds = %sw.bb.288
  br label %sw.epilog

sw.bb.296:                                        ; preds = %while.body
  %76 = load %struct._IO_FILE** %pf, align 8
  %call297 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %76, i8* getelementptr inbounds ([4 x i8]* @.str.94, i32 0, i32 0), i64* %dummy)
  %conv298 = sext i32 %call297 to i64
  store i64 %conv298, i64* %stat, align 8
  %77 = load i64* %stat, align 8
  %cmp299 = icmp ne i64 %77, 1
  br i1 %cmp299, label %if.then.301, label %if.end.303

if.then.301:                                      ; preds = %sw.bb.296
  br label %UnifiedUnreachableBlock

if.end.303:                                       ; preds = %sw.bb.296
  br label %sw.epilog

sw.bb.304:                                        ; preds = %while.body
  %78 = load %struct._IO_FILE** %pf, align 8
  %call305 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %78, i8* getelementptr inbounds ([4 x i8]* @.str.94, i32 0, i32 0), i64* %dummy)
  %conv306 = sext i32 %call305 to i64
  store i64 %conv306, i64* %stat, align 8
  %79 = load i64* %stat, align 8
  %cmp307 = icmp ne i64 %79, 1
  br i1 %cmp307, label %if.then.309, label %if.end.311

if.then.309:                                      ; preds = %sw.bb.304
  br label %UnifiedUnreachableBlock

if.end.311:                                       ; preds = %sw.bb.304
  br label %sw.epilog

sw.bb.312:                                        ; preds = %while.body
  %80 = load %struct._IO_FILE** %pf, align 8
  %arraydecay313 = getelementptr inbounds [60 x i8]* %dummy_char, i32 0, i32 0
  %call314 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %80, i8* getelementptr inbounds ([3 x i8]* @.str.85, i32 0, i32 0), i8* %arraydecay313)
  %conv315 = sext i32 %call314 to i64
  store i64 %conv315, i64* %stat, align 8
  %81 = load i64* %stat, align 8
  %cmp316 = icmp ne i64 %81, 1
  br i1 %cmp316, label %if.then.318, label %if.end.320

if.then.318:                                      ; preds = %sw.bb.312
  br label %UnifiedUnreachableBlock

if.end.320:                                       ; preds = %sw.bb.312
  br label %sw.epilog

sw.bb.321:                                        ; preds = %while.body
  %82 = load %struct._IO_FILE** %pf, align 8
  %arraydecay322 = getelementptr inbounds [30 x i8]* %opparam, i32 0, i32 0
  %call323 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %82, i8* getelementptr inbounds ([3 x i8]* @.str.85, i32 0, i32 0), i8* %arraydecay322)
  %conv324 = sext i32 %call323 to i64
  store i64 %conv324, i64* %stat, align 8
  %83 = load i64* %stat, align 8
  %cmp325 = icmp ne i64 %83, 1
  br i1 %cmp325, label %if.then.327, label %if.end.329

if.then.327:                                      ; preds = %sw.bb.321
  br label %UnifiedUnreachableBlock

if.end.329:                                       ; preds = %sw.bb.321
  %arraydecay330 = getelementptr inbounds [30 x i8]* %opparam, i32 0, i32 0
  %call331 = call i32 @strcmp(i8* %arraydecay330, i8* getelementptr inbounds ([3 x i8]* @.str.128, i32 0, i32 0))
  %cmp332 = icmp eq i32 %call331, 0
  br i1 %cmp332, label %if.then.334, label %if.end.335

if.then.334:                                      ; preds = %if.end.329
  store i64 0, i64* @ModelNorm, align 8
  br label %if.end.335

if.end.335:                                       ; preds = %if.then.334, %if.end.329
  br label %sw.epilog

sw.bb.336:                                        ; preds = %while.body
  %84 = load %struct._IO_FILE** %pf, align 8
  %arraydecay337 = getelementptr inbounds [10 x i8]* %datafile, i32 0, i32 0
  %call338 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %84, i8* getelementptr inbounds ([3 x i8]* @.str.85, i32 0, i32 0), i8* %arraydecay337)
  %conv339 = sext i32 %call338 to i64
  store i64 %conv339, i64* %stat, align 8
  %85 = load i64* %stat, align 8
  %cmp340 = icmp ne i64 %85, 1
  br i1 %cmp340, label %if.then.342, label %if.end.344

if.then.342:                                      ; preds = %sw.bb.336
  br label %UnifiedUnreachableBlock

if.end.344:                                       ; preds = %sw.bb.336
  %call346 = call i32 @strcmp(i8* undef, i8* getelementptr inbounds ([7 x i8]* @.str.130, i32 0, i32 0))
  br label %if.end.350

if.then.349:                                      ; No predecessors!
  br label %if.end.350

if.end.350:                                       ; preds = %if.end.344, %if.then.349
  br label %sw.epilog

sw.bb.351:                                        ; preds = %while.body
  %86 = load %struct._IO_FILE** %pf, align 8
  %call352 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %86, i8* getelementptr inbounds ([4 x i8]* @.str.94, i32 0, i32 0), i64* @hu_max_prims_cell)
  %conv353 = sext i32 %call352 to i64
  store i64 %conv353, i64* %stat, align 8
  %87 = load i64* %stat, align 8
  %cmp354 = icmp ne i64 %87, 1
  br i1 %cmp354, label %if.then.356, label %if.end.358

if.then.356:                                      ; preds = %sw.bb.351
  br label %UnifiedUnreachableBlock

if.end.358:                                       ; preds = %sw.bb.351
  br label %sw.epilog

sw.bb.359:                                        ; preds = %while.body
  %88 = load %struct._IO_FILE** %pf, align 8
  %call360 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %88, i8* getelementptr inbounds ([4 x i8]* @.str.94, i32 0, i32 0), i64* @hu_gridsize)
  %conv361 = sext i32 %call360 to i64
  store i64 %conv361, i64* %stat, align 8
  %89 = load i64* %stat, align 8
  %cmp362 = icmp ne i64 %89, 1
  br i1 %cmp362, label %if.then.364, label %if.end.366

if.then.364:                                      ; preds = %sw.bb.359
  br label %UnifiedUnreachableBlock

if.end.366:                                       ; preds = %sw.bb.359
  br label %sw.epilog

sw.bb.367:                                        ; preds = %while.body
  %90 = load %struct._IO_FILE** %pf, align 8
  %call368 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %90, i8* getelementptr inbounds ([4 x i8]* @.str.94, i32 0, i32 0), i64* @hu_numbuckets)
  %conv369 = sext i32 %call368 to i64
  store i64 %conv369, i64* %stat, align 8
  %91 = load i64* %stat, align 8
  %cmp370 = icmp ne i64 %91, 1
  br i1 %cmp370, label %if.then.372, label %if.end.374

if.then.372:                                      ; preds = %sw.bb.367
  br label %UnifiedUnreachableBlock

if.end.374:                                       ; preds = %sw.bb.367
  br label %sw.epilog

sw.bb.375:                                        ; preds = %while.body
  %92 = load %struct._IO_FILE** %pf, align 8
  %call376 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %92, i8* getelementptr inbounds ([4 x i8]* @.str.94, i32 0, i32 0), i64* @hu_max_subdiv_level)
  %conv377 = sext i32 %call376 to i64
  store i64 %conv377, i64* %stat, align 8
  %93 = load i64* %stat, align 8
  %cmp378 = icmp ne i64 %93, 1
  br i1 %cmp378, label %if.then.383, label %lor.lhs.false.380

lor.lhs.false.380:                                ; preds = %sw.bb.375
  %94 = load i64* @hu_max_subdiv_level, align 8
  %cmp381 = icmp sgt i64 %94, 3
  br i1 %cmp381, label %if.then.383, label %if.end.385

if.then.383:                                      ; preds = %lor.lhs.false.380, %sw.bb.375
  br label %UnifiedUnreachableBlock

if.end.385:                                       ; preds = %lor.lhs.false.380
  br label %sw.epilog

sw.bb.386:                                        ; preds = %while.body
  %95 = load %struct._IO_FILE** %pf, align 8
  %call387 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %95, i8* getelementptr inbounds ([4 x i8]* @.str.94, i32 0, i32 0), i64* @hu_lazy)
  %conv388 = sext i32 %call387 to i64
  store i64 %conv388, i64* %stat, align 8
  %96 = load i64* %stat, align 8
  %cmp389 = icmp ne i64 %96, 1
  br i1 %cmp389, label %if.then.391, label %if.end.393

if.then.391:                                      ; preds = %sw.bb.386
  br label %UnifiedUnreachableBlock

if.end.393:                                       ; preds = %sw.bb.386
  br label %sw.epilog

sw.bb.394:                                        ; preds = %while.body
  %97 = load %struct._IO_FILE** %pf, align 8
  %call395 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %97, i8* getelementptr inbounds ([8 x i8]* @.str.104, i32 0, i32 0), i64* @bundlex, i64* @bundley)
  %conv396 = sext i32 %call395 to i64
  store i64 %conv396, i64* %stat, align 8
  %98 = load i64* %stat, align 8
  %cmp397 = icmp ne i64 %98, 2
  br i1 %cmp397, label %if.then.399, label %if.end.401

if.then.399:                                      ; preds = %sw.bb.394
  br label %UnifiedUnreachableBlock

if.end.401:                                       ; preds = %sw.bb.394
  br label %sw.epilog

sw.bb.402:                                        ; preds = %while.body
  %99 = load %struct._IO_FILE** %pf, align 8
  %call403 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %99, i8* getelementptr inbounds ([8 x i8]* @.str.104, i32 0, i32 0), i64* @blockx, i64* @blocky)
  %conv404 = sext i32 %call403 to i64
  store i64 %conv404, i64* %stat, align 8
  %100 = load i64* %stat, align 8
  %cmp405 = icmp ne i64 %100, 2
  br i1 %cmp405, label %if.then.407, label %if.end.409

if.then.407:                                      ; preds = %sw.bb.402
  br label %UnifiedUnreachableBlock

if.end.409:                                       ; preds = %sw.bb.402
  br label %sw.epilog

sw.default:                                       ; preds = %while.body
  br label %sw.epilog

sw.epilog:                                        ; preds = %sw.default, %if.end.409, %if.end.401, %if.end.393, %if.end.385, %if.end.374, %if.end.366, %if.end.358, %if.end.350, %if.end.335, %if.end.320, %if.end.311, %if.end.303, %if.end.295, %if.end.287, %if.end.279, %if.end.253, %if.end.227, %if.end.210, %for.end.194, %if.end.174, %if.end.132, %if.end.124, %if.end.108, %if.end.92, %if.end.74, %if.end.58, %if.end.46, %if.end.31, %if.end.19, %if.end.11
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %101 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 5), align 8
  %102 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 6), align 8
  %mul = mul nsw i64 %101, %102
  store i64 %mul, i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 7), align 8
  %103 = load double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 10), align 8
  %104 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 5), align 8
  %conv413 = sitofp i64 %104 to double
  %div = fdiv double %103, %conv413
  store double %div, double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 14), align 8
  %105 = load double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 11), align 8
  %106 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 6), align 8
  %conv414 = sitofp i64 %106 to double
  %div415 = fdiv double %105, %conv414
  store double %div415, double* getelementptr inbounds (%struct.display* @Display, i32 0, i32 15), align 8
  %107 = load i64* %lights_set, align 8
  %tobool416 = icmp ne i64 %107, 0
  br i1 %tobool416, label %if.end.418, label %if.then.417

if.then.417:                                      ; preds = %while.end
  call void @InitLights()
  br label %if.end.418

if.end.418:                                       ; preds = %if.then.417, %while.end
  call void @InitDisplay()
  %108 = load i64* @TraversalType, align 8
  %cmp419 = icmp ne i64 %108, 0
  br i1 %cmp419, label %land.lhs.true, label %if.end.425

land.lhs.true:                                    ; preds = %if.end.418
  %109 = load i64* @ModelNorm, align 8
  %cmp421 = icmp eq i64 %109, 0
  br i1 %cmp421, label %if.then.423, label %if.end.425

if.then.423:                                      ; preds = %land.lhs.true
  store i64 1, i64* @ModelNorm, align 8
  br label %if.end.425

if.end.425:                                       ; preds = %if.then.423, %land.lhs.true, %if.end.418
  ret void

UnifiedUnreachableBlock:                          ; preds = %if.then.407, %if.then.399, %if.then.391, %if.then.383, %if.then.372, %if.then.364, %if.then.356, %if.then.342, %if.then.327, %if.then.318, %if.then.309, %if.then.301, %if.then.293, %if.then.285, %if.else.275, %if.then.260, %if.else.249, %if.then.234, %if.then.217, %if.then.201, %if.then.188, %if.then.167, %if.then.159, %if.then.152, %if.then.130, %if.then.122, %if.then.114, %if.then.106, %if.then.98, %if.then.90, %if.then.82, %if.then.72, %if.then.64, %if.then.57, %if.then.52, %if.then.44, %if.then.37, %if.then.30, %if.then.25, %if.then.17, %if.then.9, %if.then
  unreachable
}

declare %struct._IO_FILE* @fopen(i8*, i8*)

declare i32 @fscanf(%struct._IO_FILE*, i8*, ...)

declare i32 @fflush(%struct._IO_FILE*)

declare i32 @fclose(%struct._IO_FILE*)

; Function Attrs: nounwind uwtable
define internal void @RunLengthEncode(%struct._IO_FILE* %pf, %struct.pixel* %fb, i64 %xsize) {
entry:
  %pf.addr = alloca %struct._IO_FILE*, align 8
  %fb.addr = alloca %struct.pixel*, align 8
  %xsize.addr = alloca i64, align 8
  %x = alloca i64, align 8
  %rl = alloca i64, align 8
  %numpixels = alloca i64, align 8
  %red = alloca i8, align 1
  %green = alloca i8, align 1
  %blue = alloca i8, align 1
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br label %for.end

for.body:                                         ; No predecessors!
  br label %if.end

land.lhs.true:                                    ; No predecessors!
  br label %if.end

land.lhs.true.44:                                 ; No predecessors!
  br label %if.end

land.lhs.true.51:                                 ; No predecessors!
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.else:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %land.lhs.true.51, %land.lhs.true.44, %land.lhs.true, %for.body, %if.else, %if.then
  br label %for.inc

for.inc:                                          ; preds = %if.end
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %for.cond.67

for.cond.67:                                      ; preds = %for.inc.83, %for.end
  br label %for.end.85

for.body.70:                                      ; No predecessors!
  br label %for.inc.83

for.inc.83:                                       ; preds = %for.body.70
  br label %for.cond.67

for.end.85:                                       ; preds = %for.cond.67
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @OpenFrameBuffer() {
entry:
  %i = alloca i64, align 8
  %fb = alloca %struct.pixel*, align 8
  %0 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 7), align 8
  %mul = mul i64 %0, 12
  %call = call i8* @GlobalMalloc(i64 %mul, i8* getelementptr inbounds ([7 x i8]* @.str.1.141, i32 0, i32 0))
  %1 = bitcast i8* %call to %struct.pixel*
  store %struct.pixel* %1, %struct.pixel** getelementptr inbounds (%struct.display* @Display, i32 0, i32 16), align 8
  store %struct.pixel* %1, %struct.pixel** %fb, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %2 = load i64* %i, align 8
  %3 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 7), align 8
  %cmp = icmp slt i64 %2, %3
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %4 = load %struct.pixel** %fb, align 8
  %r = getelementptr inbounds %struct.pixel* %4, i32 0, i32 0
  store float 0.000000e+00, float* %r, align 4
  %5 = load %struct.pixel** %fb, align 8
  %g = getelementptr inbounds %struct.pixel* %5, i32 0, i32 1
  store float 0.000000e+00, float* %g, align 4
  %6 = load %struct.pixel** %fb, align 8
  %b = getelementptr inbounds %struct.pixel* %6, i32 0, i32 2
  store float 0.000000e+00, float* %b, align 4
  %7 = load %struct.pixel** %fb, align 8
  %incdec.ptr = getelementptr inbounds %struct.pixel* %7, i32 1
  store %struct.pixel* %incdec.ptr, %struct.pixel** %fb, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %8 = load i64* %i, align 8
  %inc = add nsw i64 %8, 1
  store i64 %inc, i64* %i, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @AddPixelColor(double* %c, i64 %x, i64 %y) {
entry:
  %c.addr = alloca double*, align 8
  %x.addr = alloca i64, align 8
  %y.addr = alloca i64, align 8
  %addr = alloca i64, align 8
  %fb = alloca %struct.pixel*, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @CloseFrameBuffer(i8* %PicFileName) {
entry:
  %PicFileName.addr = alloca i8*, align 8
  %x = alloca i64, align 8
  %y = alloca i64, align 8
  %fb = alloca %struct.pixel*, align 8
  %pf = alloca %struct._IO_FILE*, align 8
  br i1 undef, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  unreachable

if.end:                                           ; preds = %entry
  br label %for.cond

for.cond:                                         ; preds = %for.inc.99, %if.end
  br label %for.end.101

for.body:                                         ; No predecessors!
  br label %for.cond.13

for.cond.13:                                      ; preds = %for.inc, %for.body
  br label %for.end

for.body.16:                                      ; No predecessors!
  br label %cond.end

cond.true:                                        ; No predecessors!
  br label %cond.end

cond.false:                                       ; No predecessors!
  br label %cond.end

cond.end:                                         ; preds = %for.body.16, %cond.false, %cond.true
  br label %cond.end.35

cond.true.30:                                     ; No predecessors!
  br label %cond.end.35

cond.false.34:                                    ; No predecessors!
  br label %cond.end.35

cond.end.35:                                      ; preds = %cond.end, %cond.false.34, %cond.true.30
  br label %cond.end.49

cond.true.44:                                     ; No predecessors!
  br label %cond.end.49

cond.false.48:                                    ; No predecessors!
  br label %cond.end.49

cond.end.49:                                      ; preds = %cond.end.35, %cond.false.48, %cond.true.44
  br label %cond.end.64

cond.true.59:                                     ; No predecessors!
  br label %cond.end.64

cond.false.63:                                    ; No predecessors!
  br label %cond.end.64

cond.end.64:                                      ; preds = %cond.end.49, %cond.false.63, %cond.true.59
  br label %cond.end.79

cond.true.74:                                     ; No predecessors!
  br label %cond.end.79

cond.false.78:                                    ; No predecessors!
  br label %cond.end.79

cond.end.79:                                      ; preds = %cond.end.64, %cond.false.78, %cond.true.74
  br label %cond.end.94

cond.true.89:                                     ; No predecessors!
  br label %cond.end.94

cond.false.93:                                    ; No predecessors!
  br label %cond.end.94

cond.end.94:                                      ; preds = %cond.end.79, %cond.false.93, %cond.true.89
  br label %for.inc

for.inc:                                          ; preds = %cond.end.94
  br label %for.cond.13

for.end:                                          ; preds = %for.cond.13
  br label %for.inc.99

for.inc.99:                                       ; preds = %for.end
  br label %for.cond

for.end.101:                                      ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal %struct.element** @MakeElementArray(i64* %totalElements) {
entry:
  %totalElements.addr = alloca i64*, align 8
  %i = alloca i64, align 8
  %po = alloca %struct.object*, align 8
  %currArrayPosition = alloca i64, align 8
  %npepa = alloca %struct.element**, align 8
  store i64* %totalElements, i64** %totalElements.addr, align 8
  store i64 0, i64* %currArrayPosition, align 8
  %0 = load %struct.gmem** @gm, align 8
  %modelroot = getelementptr inbounds %struct.gmem* %0, i32 0, i32 3
  %1 = load %struct.object** %modelroot, align 8
  store %struct.object* %1, %struct.object** %po, align 8
  %2 = load i64** %totalElements.addr, align 8
  store i64 0, i64* %2, align 8
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %3 = load %struct.object** %po, align 8
  %tobool = icmp ne %struct.object* %3, null
  br i1 %tobool, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %4 = load %struct.object** %po, align 8
  %numelements = getelementptr inbounds %struct.object* %4, i32 0, i32 4
  %5 = load i64* %numelements, align 8
  %6 = load i64** %totalElements.addr, align 8
  %7 = load i64* %6, align 8
  %add = add nsw i64 %7, %5
  store i64 %add, i64* %6, align 8
  %8 = load %struct.object** %po, align 8
  %next = getelementptr inbounds %struct.object* %8, i32 0, i32 7
  %9 = load %struct.object** %next, align 8
  store %struct.object* %9, %struct.object** %po, align 8
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %10 = load %struct.gmem** @gm, align 8
  %modelroot1 = getelementptr inbounds %struct.gmem* %10, i32 0, i32 3
  %11 = load %struct.object** %modelroot1, align 8
  store %struct.object* %11, %struct.object** %po, align 8
  %12 = load i64** %totalElements.addr, align 8
  %13 = load i64* %12, align 8
  %call = call i8* @ObjectMalloc(i64 7, i64 %13)
  %14 = bitcast i8* %call to %struct.element**
  store %struct.element** %14, %struct.element*** %npepa, align 8
  br label %while.cond.2

while.cond.2:                                     ; preds = %for.end, %while.end
  %15 = load %struct.object** %po, align 8
  %tobool3 = icmp ne %struct.object* %15, null
  br i1 %tobool3, label %while.body.4, label %while.end.8

while.body.4:                                     ; preds = %while.cond.2
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %while.body.4
  %16 = load i64* %i, align 8
  %17 = load %struct.object** %po, align 8
  %numelements5 = getelementptr inbounds %struct.object* %17, i32 0, i32 4
  %18 = load i64* %numelements5, align 8
  %cmp = icmp slt i64 %16, %18
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %19 = load %struct.object** %po, align 8
  %pelem = getelementptr inbounds %struct.object* %19, i32 0, i32 3
  %20 = load %struct.element** %pelem, align 8
  %21 = load i64* %i, align 8
  %add.ptr = getelementptr inbounds %struct.element* %20, i64 %21
  %22 = load i64* %currArrayPosition, align 8
  %inc = add nsw i64 %22, 1
  store i64 %inc, i64* %currArrayPosition, align 8
  %23 = load %struct.element*** %npepa, align 8
  %arrayidx = getelementptr inbounds %struct.element** %23, i64 %22
  store %struct.element* %add.ptr, %struct.element** %arrayidx, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %24 = load i64* %i, align 8
  %inc6 = add nsw i64 %24, 1
  store i64 %inc6, i64* %i, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %25 = load %struct.object** %po, align 8
  %next7 = getelementptr inbounds %struct.object* %25, i32 0, i32 7
  %26 = load %struct.object** %next7, align 8
  store %struct.object* %26, %struct.object** %po, align 8
  br label %while.cond.2

while.end.8:                                      ; preds = %while.cond.2
  %27 = load %struct.element*** %npepa, align 8
  ret %struct.element** %27
}

; Function Attrs: nounwind uwtable
define internal void @PrintGeo(%struct.object* %po) {
entry:
  %po.addr = alloca %struct.object*, align 8
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  br label %while.end

while.body:                                       ; No predecessors!
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @NormalizeGeo(%struct.object* %po, [4 x double]* %model, [4 x double]* %modelInvT) {
entry:
  %po.addr = alloca %struct.object*, align 8
  %model.addr = alloca [4 x double]*, align 8
  %modelInvT.addr = alloca [4 x double]*, align 8
  %norm_minx = alloca double, align 8
  %norm_miny = alloca double, align 8
  %norm_minz = alloca double, align 8
  %norm_maxx = alloca double, align 8
  %norm_maxy = alloca double, align 8
  %norm_maxz = alloca double, align 8
  %scale_min = alloca double, align 8
  %scale_max = alloca double, align 8
  %scale = alloca double, align 8
  %trans = alloca double, align 8
  %poHead = alloca %struct.object*, align 8
  %normMat = alloca [4 x [4 x double]], align 16
  %tempMat = alloca [4 x [4 x double]], align 16
  store %struct.object* %po, %struct.object** %po.addr, align 8
  %0 = load i64* @TraversalType, align 8
  %cmp = icmp eq i64 %0, 0
  br i1 %cmp, label %land.lhs.true, label %if.then

land.lhs.true:                                    ; preds = %entry
  %1 = load i64* @ModelNorm, align 8
  %cmp1 = icmp eq i64 %1, 0
  br i1 %cmp1, label %if.end, label %if.then

if.then:                                          ; preds = %land.lhs.true, %entry
  store double 1.000000e+32, double* %norm_minz, align 8
  store double 1.000000e+32, double* %norm_miny, align 8
  store double 1.000000e+32, double* %norm_minx, align 8
  store double -1.000000e+32, double* %norm_maxz, align 8
  store double -1.000000e+32, double* %norm_maxy, align 8
  store double -1.000000e+32, double* %norm_maxx, align 8
  br label %while.cond

while.cond:                                       ; preds = %cond.end.58, %if.then
  %2 = load %struct.object** %po.addr, align 8
  %tobool = icmp ne %struct.object* %2, null
  br i1 %tobool, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %3 = load double* %norm_minx, align 8
  %4 = load %struct.object** %po.addr, align 8
  %bv = getelementptr inbounds %struct.object* %4, i32 0, i32 2
  %dnear = getelementptr inbounds %struct.bbox* %bv, i32 0, i32 0
  %arrayidx = getelementptr inbounds [3 x double]* %dnear, i32 0, i64 0
  %5 = load double* %arrayidx, align 8
  %cmp2 = fcmp olt double %3, %5
  br i1 %cmp2, label %cond.true, label %cond.false

cond.true:                                        ; preds = %while.body
  %6 = load double* %norm_minx, align 8
  br label %cond.end

cond.false:                                       ; preds = %while.body
  %7 = load %struct.object** %po.addr, align 8
  %bv3 = getelementptr inbounds %struct.object* %7, i32 0, i32 2
  %dnear4 = getelementptr inbounds %struct.bbox* %bv3, i32 0, i32 0
  %arrayidx5 = getelementptr inbounds [3 x double]* %dnear4, i32 0, i64 0
  %8 = load double* %arrayidx5, align 8
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi double [ %6, %cond.true ], [ %8, %cond.false ]
  store double %cond, double* %norm_minx, align 8
  %9 = load double* %norm_miny, align 8
  %10 = load %struct.object** %po.addr, align 8
  %bv6 = getelementptr inbounds %struct.object* %10, i32 0, i32 2
  %dnear7 = getelementptr inbounds %struct.bbox* %bv6, i32 0, i32 0
  %arrayidx8 = getelementptr inbounds [3 x double]* %dnear7, i32 0, i64 1
  %11 = load double* %arrayidx8, align 8
  %cmp9 = fcmp olt double %9, %11
  br i1 %cmp9, label %cond.true.10, label %cond.false.11

cond.true.10:                                     ; preds = %cond.end
  %12 = load double* %norm_miny, align 8
  br label %cond.end.15

cond.false.11:                                    ; preds = %cond.end
  %13 = load %struct.object** %po.addr, align 8
  %bv12 = getelementptr inbounds %struct.object* %13, i32 0, i32 2
  %dnear13 = getelementptr inbounds %struct.bbox* %bv12, i32 0, i32 0
  %arrayidx14 = getelementptr inbounds [3 x double]* %dnear13, i32 0, i64 1
  %14 = load double* %arrayidx14, align 8
  br label %cond.end.15

cond.end.15:                                      ; preds = %cond.false.11, %cond.true.10
  %cond16 = phi double [ %12, %cond.true.10 ], [ %14, %cond.false.11 ]
  store double %cond16, double* %norm_miny, align 8
  %15 = load double* %norm_minz, align 8
  %16 = load %struct.object** %po.addr, align 8
  %bv17 = getelementptr inbounds %struct.object* %16, i32 0, i32 2
  %dnear18 = getelementptr inbounds %struct.bbox* %bv17, i32 0, i32 0
  %arrayidx19 = getelementptr inbounds [3 x double]* %dnear18, i32 0, i64 2
  %17 = load double* %arrayidx19, align 8
  %cmp20 = fcmp olt double %15, %17
  br i1 %cmp20, label %cond.true.21, label %cond.false.22

cond.true.21:                                     ; preds = %cond.end.15
  %18 = load double* %norm_minz, align 8
  br label %cond.end.26

cond.false.22:                                    ; preds = %cond.end.15
  %19 = load %struct.object** %po.addr, align 8
  %bv23 = getelementptr inbounds %struct.object* %19, i32 0, i32 2
  %dnear24 = getelementptr inbounds %struct.bbox* %bv23, i32 0, i32 0
  %arrayidx25 = getelementptr inbounds [3 x double]* %dnear24, i32 0, i64 2
  %20 = load double* %arrayidx25, align 8
  br label %cond.end.26

cond.end.26:                                      ; preds = %cond.false.22, %cond.true.21
  %cond27 = phi double [ %18, %cond.true.21 ], [ %20, %cond.false.22 ]
  store double %cond27, double* %norm_minz, align 8
  %21 = load double* %norm_maxx, align 8
  %22 = load %struct.object** %po.addr, align 8
  %bv28 = getelementptr inbounds %struct.object* %22, i32 0, i32 2
  %dfar = getelementptr inbounds %struct.bbox* %bv28, i32 0, i32 1
  %arrayidx29 = getelementptr inbounds [3 x double]* %dfar, i32 0, i64 0
  %23 = load double* %arrayidx29, align 8
  %cmp30 = fcmp ogt double %21, %23
  br i1 %cmp30, label %cond.true.31, label %cond.false.32

cond.true.31:                                     ; preds = %cond.end.26
  %24 = load double* %norm_maxx, align 8
  br label %cond.end.36

cond.false.32:                                    ; preds = %cond.end.26
  %25 = load %struct.object** %po.addr, align 8
  %bv33 = getelementptr inbounds %struct.object* %25, i32 0, i32 2
  %dfar34 = getelementptr inbounds %struct.bbox* %bv33, i32 0, i32 1
  %arrayidx35 = getelementptr inbounds [3 x double]* %dfar34, i32 0, i64 0
  %26 = load double* %arrayidx35, align 8
  br label %cond.end.36

cond.end.36:                                      ; preds = %cond.false.32, %cond.true.31
  %cond37 = phi double [ %24, %cond.true.31 ], [ %26, %cond.false.32 ]
  store double %cond37, double* %norm_maxx, align 8
  %27 = load double* %norm_maxy, align 8
  %28 = load %struct.object** %po.addr, align 8
  %bv38 = getelementptr inbounds %struct.object* %28, i32 0, i32 2
  %dfar39 = getelementptr inbounds %struct.bbox* %bv38, i32 0, i32 1
  %arrayidx40 = getelementptr inbounds [3 x double]* %dfar39, i32 0, i64 1
  %29 = load double* %arrayidx40, align 8
  %cmp41 = fcmp ogt double %27, %29
  br i1 %cmp41, label %cond.true.42, label %cond.false.43

cond.true.42:                                     ; preds = %cond.end.36
  %30 = load double* %norm_maxy, align 8
  br label %cond.end.47

cond.false.43:                                    ; preds = %cond.end.36
  %31 = load %struct.object** %po.addr, align 8
  %bv44 = getelementptr inbounds %struct.object* %31, i32 0, i32 2
  %dfar45 = getelementptr inbounds %struct.bbox* %bv44, i32 0, i32 1
  %arrayidx46 = getelementptr inbounds [3 x double]* %dfar45, i32 0, i64 1
  %32 = load double* %arrayidx46, align 8
  br label %cond.end.47

cond.end.47:                                      ; preds = %cond.false.43, %cond.true.42
  %cond48 = phi double [ %30, %cond.true.42 ], [ %32, %cond.false.43 ]
  store double %cond48, double* %norm_maxy, align 8
  %33 = load double* %norm_maxz, align 8
  %34 = load %struct.object** %po.addr, align 8
  %bv49 = getelementptr inbounds %struct.object* %34, i32 0, i32 2
  %dfar50 = getelementptr inbounds %struct.bbox* %bv49, i32 0, i32 1
  %arrayidx51 = getelementptr inbounds [3 x double]* %dfar50, i32 0, i64 2
  %35 = load double* %arrayidx51, align 8
  %cmp52 = fcmp ogt double %33, %35
  br i1 %cmp52, label %cond.true.53, label %cond.false.54

cond.true.53:                                     ; preds = %cond.end.47
  %36 = load double* %norm_maxz, align 8
  br label %cond.end.58

cond.false.54:                                    ; preds = %cond.end.47
  %37 = load %struct.object** %po.addr, align 8
  %bv55 = getelementptr inbounds %struct.object* %37, i32 0, i32 2
  %dfar56 = getelementptr inbounds %struct.bbox* %bv55, i32 0, i32 1
  %arrayidx57 = getelementptr inbounds [3 x double]* %dfar56, i32 0, i64 2
  %38 = load double* %arrayidx57, align 8
  br label %cond.end.58

cond.end.58:                                      ; preds = %cond.false.54, %cond.true.53
  %cond59 = phi double [ %36, %cond.true.53 ], [ %38, %cond.false.54 ]
  store double %cond59, double* %norm_maxz, align 8
  %39 = load %struct.object** %po.addr, align 8
  %next = getelementptr inbounds %struct.object* %39, i32 0, i32 7
  %40 = load %struct.object** %next, align 8
  store %struct.object* %40, %struct.object** %po.addr, align 8
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %41 = load double* %norm_minx, align 8
  %42 = load double* %norm_miny, align 8
  %cmp60 = fcmp olt double %41, %42
  br i1 %cmp60, label %cond.true.61, label %cond.false.62

cond.true.61:                                     ; preds = %while.end
  %43 = load double* %norm_minx, align 8
  br label %cond.end.63

cond.false.62:                                    ; preds = %while.end
  %44 = load double* %norm_miny, align 8
  br label %cond.end.63

cond.end.63:                                      ; preds = %cond.false.62, %cond.true.61
  %cond64 = phi double [ %43, %cond.true.61 ], [ %44, %cond.false.62 ]
  store double %cond64, double* %scale_min, align 8
  %45 = load double* %scale_min, align 8
  %46 = load double* %norm_minz, align 8
  %cmp65 = fcmp olt double %45, %46
  br i1 %cmp65, label %cond.true.66, label %cond.false.67

cond.true.66:                                     ; preds = %cond.end.63
  %47 = load double* %scale_min, align 8
  br label %cond.end.68

cond.false.67:                                    ; preds = %cond.end.63
  %48 = load double* %norm_minz, align 8
  br label %cond.end.68

cond.end.68:                                      ; preds = %cond.false.67, %cond.true.66
  %cond69 = phi double [ %47, %cond.true.66 ], [ %48, %cond.false.67 ]
  store double %cond69, double* %scale_min, align 8
  %49 = load double* %norm_maxx, align 8
  %50 = load double* %norm_maxy, align 8
  %cmp70 = fcmp ogt double %49, %50
  br i1 %cmp70, label %cond.true.71, label %cond.false.72

cond.true.71:                                     ; preds = %cond.end.68
  %51 = load double* %norm_maxx, align 8
  br label %cond.end.73

cond.false.72:                                    ; preds = %cond.end.68
  %52 = load double* %norm_maxy, align 8
  br label %cond.end.73

cond.end.73:                                      ; preds = %cond.false.72, %cond.true.71
  %cond74 = phi double [ %51, %cond.true.71 ], [ %52, %cond.false.72 ]
  store double %cond74, double* %scale_max, align 8
  %53 = load double* %scale_max, align 8
  %54 = load double* %norm_maxz, align 8
  %cmp75 = fcmp ogt double %53, %54
  br i1 %cmp75, label %cond.true.76, label %cond.false.77

cond.true.76:                                     ; preds = %cond.end.73
  %55 = load double* %scale_max, align 8
  br label %cond.end.78

cond.false.77:                                    ; preds = %cond.end.73
  %56 = load double* %norm_maxz, align 8
  br label %cond.end.78

cond.end.78:                                      ; preds = %cond.false.77, %cond.true.76
  %cond79 = phi double [ %55, %cond.true.76 ], [ %56, %cond.false.77 ]
  store double %cond79, double* %scale_max, align 8
  %57 = load double* %scale_max, align 8
  %58 = load double* %scale_min, align 8
  %sub = fsub double %57, %58
  %div = fdiv double 1.000000e+00, %sub
  store double %div, double* %scale, align 8
  %59 = load double* %scale_min, align 8
  %sub80 = fsub double -0.000000e+00, %59
  %60 = load double* %scale, align 8
  %mul = fmul double %sub80, %60
  store double %mul, double* %trans, align 8
  %arraydecay = getelementptr inbounds [4 x [4 x double]]* %tempMat, i32 0, i32 0
  %61 = load double* %scale, align 8
  call void @Scale([4 x double]* %arraydecay, double %61, double undef, double undef)
  %arraydecay81 = getelementptr inbounds [4 x [4 x double]]* %normMat, i32 0, i32 0
  %62 = load double* %trans, align 8
  call void @Translate([4 x double]* %arraydecay81, double undef, double undef, double %62)
  %arraydecay82 = getelementptr inbounds [4 x [4 x double]]* %normMat, i32 0, i32 0
  %arraydecay83 = getelementptr inbounds [4 x [4 x double]]* %tempMat, i32 0, i32 0
  %arraydecay84 = getelementptr inbounds [4 x [4 x double]]* %normMat, i32 0, i32 0
  call void @MatrixMult([4 x double]* %arraydecay82, [4 x double]* %arraydecay83, [4 x double]* %arraydecay84)
  br label %while.cond.85

while.cond.85:                                    ; preds = %while.body.87, %cond.end.78
  br label %while.end.90

while.body.87:                                    ; No predecessors!
  br label %while.cond.85

while.end.90:                                     ; preds = %while.cond.85
  br label %if.end

if.end:                                           ; preds = %while.end.90, %land.lhs.true
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @ReadGeoFile(i8* %GeoFileName) {
entry:
  %GeoFileName.addr = alloca i8*, align 8
  %i = alloca i64, align 8
  %dummy = alloca i64, align 8
  %stat = alloca i64, align 8
  %comchar = alloca i8, align 1
  %primop = alloca i8, align 1
  %objstr = alloca [30 x i8], align 16
  %objname = alloca [30 x i8], align 16
  %pf = alloca %struct._IO_FILE*, align 8
  %ps = alloca %struct.surf*, align 8
  %model = alloca [4 x [4 x double]], align 16
  %modelInv = alloca [4 x [4 x double]], align 16
  %modelInvT = alloca [4 x [4 x double]], align 16
  %po = alloca %struct.object*, align 8
  %prev = alloca %struct.object*, align 8
  %curr = alloca %struct.object*, align 8
  %pe = alloca %struct.element*, align 8
  store i8* %GeoFileName, i8** %GeoFileName.addr, align 8
  %0 = load i8** %GeoFileName.addr, align 8
  %call = call %struct._IO_FILE* @fopen(i8* %0, i8* getelementptr inbounds ([2 x i8]* @.str.3.148, i32 0, i32 0))
  store %struct._IO_FILE* %call, %struct._IO_FILE** %pf, align 8
  %1 = load %struct._IO_FILE** %pf, align 8
  %tobool = icmp ne %struct._IO_FILE* %1, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  br label %UnifiedUnreachableBlock

if.end:                                           ; preds = %entry
  store %struct.object* null, %struct.object** %curr, align 8
  store %struct.object* null, %struct.object** %prev, align 8
  %2 = load %struct.gmem** @gm, align 8
  %modelroot = getelementptr inbounds %struct.gmem* %2, i32 0, i32 3
  store %struct.object* null, %struct.object** %modelroot, align 8
  store i64 0, i64* @prim_obj_cnt, align 8
  %arraydecay = getelementptr inbounds [4 x [4 x double]]* %model, i32 0, i32 0
  call void @MatrixCopy([4 x double]* %arraydecay, [4 x double]* getelementptr inbounds (%struct.view* @View, i32 0, i32 4, i32 0))
  %arraydecay2 = getelementptr inbounds [4 x [4 x double]]* %modelInv, i32 0, i32 0
  %arraydecay3 = getelementptr inbounds [4 x [4 x double]]* %model, i32 0, i32 0
  call void @MatrixInverse([4 x double]* %arraydecay2, [4 x double]* %arraydecay3)
  %arraydecay4 = getelementptr inbounds [4 x [4 x double]]* %modelInvT, i32 0, i32 0
  %arraydecay5 = getelementptr inbounds [4 x [4 x double]]* %modelInv, i32 0, i32 0
  call void @MatrixTranspose([4 x double]* %arraydecay4, [4 x double]* %arraydecay5)
  %3 = load %struct._IO_FILE** %pf, align 8
  %call6 = call i32 @_IO_getc(%struct._IO_FILE* %3)
  %conv = trunc i32 %call6 to i8
  %conv7 = sext i8 %conv to i32
  %cmp = icmp ne i32 %conv7, 35
  br i1 %cmp, label %if.then.9, label %if.else

if.then.9:                                        ; preds = %if.end
  br label %if.end.23

if.else:                                          ; preds = %if.end
  store i8 0, i8* %comchar, align 1
  br label %while.cond

while.cond:                                       ; preds = %if.end.22, %if.else
  %4 = load i8* %comchar, align 1
  %conv12 = sext i8 %4 to i32
  %cmp13 = icmp ne i32 %conv12, 35
  br i1 %cmp13, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %5 = load %struct._IO_FILE** %pf, align 8
  %call15 = call i32 @_IO_getc(%struct._IO_FILE* %5)
  %conv16 = trunc i32 %call15 to i8
  store i8 %conv16, i8* %comchar, align 1
  %conv17 = sext i8 %conv16 to i32
  %cmp18 = icmp eq i32 %conv17, -1
  br i1 %cmp18, label %if.then.20, label %if.end.22

if.then.20:                                       ; preds = %while.body
  br label %UnifiedUnreachableBlock

if.end.22:                                        ; preds = %while.body
  br label %while.cond

while.end:                                        ; preds = %while.cond
  br label %if.end.23

if.end.23:                                        ; preds = %while.end, %if.then.9
  br label %while.cond.24

while.cond.24:                                    ; preds = %for.end, %if.end.23
  %6 = load %struct._IO_FILE** %pf, align 8
  %arraydecay25 = getelementptr inbounds [30 x i8]* %objstr, i32 0, i32 0
  %arraydecay26 = getelementptr inbounds [30 x i8]* %objname, i32 0, i32 0
  %call27 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %6, i8* getelementptr inbounds ([6 x i8]* @.str.6.151, i32 0, i32 0), i8* %arraydecay25, i8* %arraydecay26)
  %conv28 = sext i32 %call27 to i64
  store i64 %conv28, i64* %stat, align 8
  %cmp29 = icmp ne i64 %conv28, -1
  br i1 %cmp29, label %while.body.31, label %while.end.116

while.body.31:                                    ; preds = %while.cond.24
  %7 = load i64* %stat, align 8
  %cmp32 = icmp ne i64 %7, 2
  br i1 %cmp32, label %if.then.38, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %while.body.31
  %arraydecay34 = getelementptr inbounds [30 x i8]* %objstr, i32 0, i32 0
  %call35 = call i32 @strcmp(i8* %arraydecay34, i8* getelementptr inbounds ([7 x i8]* @.str.7.152, i32 0, i32 0))
  %cmp36 = icmp ne i32 %call35, 0
  br i1 %cmp36, label %if.then.38, label %if.end.41

if.then.38:                                       ; preds = %lor.lhs.false, %while.body.31
  br label %UnifiedUnreachableBlock

if.end.41:                                        ; preds = %lor.lhs.false
  %8 = load i64* @prim_obj_cnt, align 8
  %inc = add nsw i64 %8, 1
  store i64 %inc, i64* @prim_obj_cnt, align 8
  %call42 = call i8* @GlobalMalloc(i64 128, i8* getelementptr inbounds ([6 x i8]* @.str.9.154, i32 0, i32 0))
  %9 = bitcast i8* %call42 to %struct.object*
  store %struct.object* %9, %struct.object** %curr, align 8
  %10 = load i64* @prim_obj_cnt, align 8
  %11 = load %struct.object** %curr, align 8
  %index = getelementptr inbounds %struct.object* %11, i32 0, i32 0
  store i64 %10, i64* %index, align 8
  %12 = load %struct.object** %curr, align 8
  %next = getelementptr inbounds %struct.object* %12, i32 0, i32 7
  store %struct.object* null, %struct.object** %next, align 8
  %13 = load %struct.gmem** @gm, align 8
  %modelroot46 = getelementptr inbounds %struct.gmem* %13, i32 0, i32 3
  %14 = load %struct.object** %modelroot46, align 8
  %cmp47 = icmp eq %struct.object* %14, null
  br i1 %cmp47, label %if.then.49, label %if.else.51

if.then.49:                                       ; preds = %if.end.41
  %15 = load %struct.object** %curr, align 8
  %16 = load %struct.gmem** @gm, align 8
  %modelroot50 = getelementptr inbounds %struct.gmem* %16, i32 0, i32 3
  store %struct.object* %15, %struct.object** %modelroot50, align 8
  br label %if.end.53

if.else.51:                                       ; preds = %if.end.41
  %17 = load %struct.object** %curr, align 8
  %18 = load %struct.object** %prev, align 8
  %next52 = getelementptr inbounds %struct.object* %18, i32 0, i32 7
  store %struct.object* %17, %struct.object** %next52, align 8
  br label %if.end.53

if.end.53:                                        ; preds = %if.else.51, %if.then.49
  %call54 = call i8* @GlobalMalloc(i64 88, i8* getelementptr inbounds ([6 x i8]* @.str.9.154, i32 0, i32 0))
  %19 = bitcast i8* %call54 to %struct.surf*
  store %struct.surf* %19, %struct.surf** %ps, align 8
  %20 = load %struct.surf** %ps, align 8
  %21 = load %struct.object** %curr, align 8
  %surf = getelementptr inbounds %struct.object* %21, i32 0, i32 6
  store %struct.surf* %20, %struct.surf** %surf, align 8
  %22 = load %struct._IO_FILE** %pf, align 8
  %23 = load %struct.surf** %ps, align 8
  %fcolor = getelementptr inbounds %struct.surf* %23, i32 0, i32 0
  %arrayidx = getelementptr inbounds [3 x double]* %fcolor, i32 0, i64 0
  %24 = load %struct.surf** %ps, align 8
  %fcolor55 = getelementptr inbounds %struct.surf* %24, i32 0, i32 0
  %arrayidx56 = getelementptr inbounds [3 x double]* %fcolor55, i32 0, i64 1
  %25 = load %struct.surf** %ps, align 8
  %fcolor57 = getelementptr inbounds %struct.surf* %25, i32 0, i32 0
  %arrayidx58 = getelementptr inbounds [3 x double]* %fcolor57, i32 0, i64 2
  %26 = load %struct.surf** %ps, align 8
  %bcolor = getelementptr inbounds %struct.surf* %26, i32 0, i32 1
  %arrayidx59 = getelementptr inbounds [3 x double]* %bcolor, i32 0, i64 0
  %27 = load %struct.surf** %ps, align 8
  %bcolor60 = getelementptr inbounds %struct.surf* %27, i32 0, i32 1
  %arrayidx61 = getelementptr inbounds [3 x double]* %bcolor60, i32 0, i64 1
  %28 = load %struct.surf** %ps, align 8
  %bcolor62 = getelementptr inbounds %struct.surf* %28, i32 0, i32 1
  %arrayidx63 = getelementptr inbounds [3 x double]* %bcolor62, i32 0, i64 2
  %call64 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %22, i8* getelementptr inbounds ([24 x i8]* @.str.10.155, i32 0, i32 0), double* %arrayidx, double* %arrayidx56, double* %arrayidx58, double* %arrayidx59, double* %arrayidx61, double* %arrayidx63)
  %conv65 = sext i32 %call64 to i64
  store i64 %conv65, i64* %stat, align 8
  %29 = load i64* %stat, align 8
  %cmp66 = icmp ne i64 %29, 6
  br i1 %cmp66, label %if.then.68, label %if.end.70

if.then.68:                                       ; preds = %if.end.53
  br label %UnifiedUnreachableBlock

if.end.70:                                        ; preds = %if.end.53
  %30 = load %struct._IO_FILE** %pf, align 8
  %31 = load %struct.surf** %ps, align 8
  %kdiff = getelementptr inbounds %struct.surf* %31, i32 0, i32 2
  %32 = load %struct.surf** %ps, align 8
  %kspec = getelementptr inbounds %struct.surf* %32, i32 0, i32 3
  %33 = load %struct.surf** %ps, align 8
  %ktran = getelementptr inbounds %struct.surf* %33, i32 0, i32 4
  %34 = load %struct.surf** %ps, align 8
  %refrindex = getelementptr inbounds %struct.surf* %34, i32 0, i32 5
  %35 = load %struct.surf** %ps, align 8
  %kspecn = getelementptr inbounds %struct.surf* %35, i32 0, i32 6
  %call71 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %30, i8* getelementptr inbounds ([20 x i8]* @.str.12.157, i32 0, i32 0), double* %kdiff, double* %kspec, double* %ktran, double* %refrindex, double* %kspecn)
  %conv72 = sext i32 %call71 to i64
  store i64 %conv72, i64* %stat, align 8
  %36 = load i64* %stat, align 8
  %cmp73 = icmp ne i64 %36, 5
  br i1 %cmp73, label %if.then.75, label %if.end.77

if.then.75:                                       ; preds = %if.end.70
  br label %UnifiedUnreachableBlock

if.end.77:                                        ; preds = %if.end.70
  %37 = load %struct._IO_FILE** %pf, align 8
  %call78 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %37, i8* getelementptr inbounds ([17 x i8]* @.str.14.159, i32 0, i32 0), i64* %dummy, i64* %dummy, i64* %dummy, i64* %dummy)
  %conv79 = sext i32 %call78 to i64
  store i64 %conv79, i64* %stat, align 8
  %38 = load i64* %stat, align 8
  %cmp80 = icmp ne i64 %38, 4
  br i1 %cmp80, label %if.then.82, label %if.end.84

if.then.82:                                       ; preds = %if.end.77
  br label %UnifiedUnreachableBlock

if.end.84:                                        ; preds = %if.end.77
  %39 = load %struct._IO_FILE** %pf, align 8
  %40 = load %struct.object** %curr, align 8
  %numelements = getelementptr inbounds %struct.object* %40, i32 0, i32 4
  %call85 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %39, i8* getelementptr inbounds ([7 x i8]* @.str.16.161, i32 0, i32 0), i8* %primop, i64* %numelements)
  %conv86 = sext i32 %call85 to i64
  store i64 %conv86, i64* %stat, align 8
  %41 = load i64* %stat, align 8
  %cmp87 = icmp ne i64 %41, 2
  br i1 %cmp87, label %if.then.89, label %if.end.91

if.then.89:                                       ; preds = %if.end.84
  br label %UnifiedUnreachableBlock

if.end.91:                                        ; preds = %if.end.84
  %42 = load i8* %primop, align 1
  %conv92 = sext i8 %42 to i32
  switch i32 %conv92, label %sw.default [
    i32 115, label %sw.bb
    i32 112, label %sw.bb.93
    i32 116, label %sw.bb.95
    i32 99, label %sw.bb.97
    i32 113, label %sw.bb.97
  ]

sw.bb:                                            ; preds = %if.end.91
  %43 = load %struct.object** %curr, align 8
  %procs = getelementptr inbounds %struct.object* %43, i32 0, i32 5
  store %struct.pprocs* @SphProcs, %struct.pprocs** %procs, align 8
  br label %sw.epilog

sw.bb.93:                                         ; preds = %if.end.91
  %44 = load %struct.object** %curr, align 8
  %procs94 = getelementptr inbounds %struct.object* %44, i32 0, i32 5
  store %struct.pprocs* @PolyProcs, %struct.pprocs** %procs94, align 8
  br label %sw.epilog

sw.bb.95:                                         ; preds = %if.end.91
  %45 = load %struct.object** %curr, align 8
  %procs96 = getelementptr inbounds %struct.object* %45, i32 0, i32 5
  store %struct.pprocs* @TriProcs, %struct.pprocs** %procs96, align 8
  br label %sw.epilog

sw.bb.97:                                         ; preds = %if.end.91, %if.end.91
  br label %UnifiedUnreachableBlock

sw.default:                                       ; preds = %if.end.91
  br label %UnifiedUnreachableBlock

sw.epilog:                                        ; preds = %sw.bb.95, %sw.bb.93, %sw.bb
  %46 = load %struct.object** %curr, align 8
  %numelements101 = getelementptr inbounds %struct.object* %46, i32 0, i32 4
  %47 = load i64* %numelements101, align 8
  %mul = mul i64 72, %47
  %call102 = call i8* @GlobalMalloc(i64 %mul, i8* getelementptr inbounds ([6 x i8]* @.str.9.154, i32 0, i32 0))
  %48 = bitcast i8* %call102 to %struct.element*
  store %struct.element* %48, %struct.element** %pe, align 8
  %49 = load %struct.element** %pe, align 8
  %50 = load %struct.object** %curr, align 8
  %pelem = getelementptr inbounds %struct.object* %50, i32 0, i32 3
  store %struct.element* %49, %struct.element** %pelem, align 8
  store i64 1, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %sw.epilog
  %51 = load i64* %i, align 8
  %52 = load %struct.object** %curr, align 8
  %numelements104 = getelementptr inbounds %struct.object* %52, i32 0, i32 4
  %53 = load i64* %numelements104, align 8
  %cmp105 = icmp sle i64 %51, %53
  br i1 %cmp105, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %54 = load i64* %i, align 8
  %55 = load %struct.element** %pe, align 8
  %index107 = getelementptr inbounds %struct.element* %55, i32 0, i32 0
  store i64 %54, i64* %index107, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %56 = load i64* %i, align 8
  %inc108 = add nsw i64 %56, 1
  store i64 %inc108, i64* %i, align 8
  %57 = load %struct.element** %pe, align 8
  %incdec.ptr = getelementptr inbounds %struct.element* %57, i32 1
  store %struct.element* %incdec.ptr, %struct.element** %pe, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %58 = load %struct.object** %curr, align 8
  store %struct.object* %58, %struct.object** %prev, align 8
  br label %while.cond.24

while.end.116:                                    ; preds = %while.cond.24
  %59 = load %struct.gmem** @gm, align 8
  %modelroot117 = getelementptr inbounds %struct.gmem* %59, i32 0, i32 3
  %60 = load %struct.object** %modelroot117, align 8
  call void @NormalizeGeo(%struct.object* %60, [4 x double]* undef, [4 x double]* undef)
  ret void

UnifiedUnreachableBlock:                          ; preds = %sw.default, %sw.bb.97, %if.then.89, %if.then.82, %if.then.75, %if.then.68, %if.then.38, %if.then.20, %if.then
  unreachable
}

declare i32 @_IO_getc(%struct._IO_FILE*)

declare i32 @ungetc(i32, %struct._IO_FILE*)

declare i8* @strcpy(i8*, i8*)

; Function Attrs: nounwind uwtable
define internal void @prn_voxel(%struct.voxel* %v) {
entry:
  %v.addr = alloca %struct.voxel*, align 8
  %pe = alloca %struct.element*, align 8
  %pepa = alloca %struct.element**, align 8
  %g = alloca %struct.grid*, align 8
  %i = alloca i64, align 8
  br label %if.end

if.then:                                          ; No predecessors!
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.then
  br label %for.end

for.body:                                         ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %if.end

if.end:                                           ; preds = %entry, %for.end
  br label %if.end.18

if.then.14:                                       ; No predecessors!
  br label %if.end.18

if.end.18:                                        ; preds = %if.end, %if.then.14
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @prn_grid(%struct.grid* %g) {
entry:
  %g.addr = alloca %struct.grid*, align 8
  %i = alloca i64, align 8
  %n = alloca i64, align 8
  %cnt = alloca i64, align 8
  %ng = alloca %struct.grid*, align 8
  %v = alloca %struct.voxel*, align 8
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.else:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %entry, %if.else, %if.then
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end
  br label %for.end

for.body:                                         ; No predecessors!
  br label %if.end.37

if.then.33:                                       ; No predecessors!
  br label %if.end.37

if.else.35:                                       ; No predecessors!
  br label %if.end.37

if.end.37:                                        ; preds = %for.body, %if.else.35, %if.then.33
  br label %for.inc

for.inc:                                          ; preds = %if.end.37
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @prn_ray(%struct.ray* %r) {
entry:
  %r.addr = alloca %struct.ray*, align 8
  %ri = alloca %struct.rayinfo*, align 8
  %g = alloca %struct.grid*, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @prn_PrimElem(%struct.element* %p) {
entry:
  %p.addr = alloca %struct.element*, align 8
  %b = alloca %struct.bbox, align 8
  br i1 undef, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  unreachable

if.end:                                           ; preds = %entry
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @prn_bintree_node(%struct.btnode* %b) {
entry:
  %b.addr = alloca %struct.btnode*, align 8
  %i = alloca i64, align 8
  br label %if.end.30

if.then:                                          ; No predecessors!
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.then
  br label %for.end

for.body:                                         ; No predecessors!
  br label %if.end

if.then.28:                                       ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %for.body, %if.then.28
  br label %for.inc

for.inc:                                          ; preds = %if.end
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %if.end.30

if.end.30:                                        ; preds = %entry, %for.end
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @prn_bintree_leaves(%struct.btnode* %root) {
entry:
  %root.addr = alloca %struct.btnode*, align 8
  %b = alloca %struct.btnode*, align 8
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.else:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %entry, %if.else, %if.then
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @prn_pepa_prim_list(%struct.element** %pepa, i64 %nprims) {
entry:
  %pepa.addr = alloca %struct.element**, align 8
  %nprims.addr = alloca i64, align 8
  %i = alloca i64, align 8
  br label %if.end.5

if.then:                                          ; No predecessors!
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.then
  br label %for.end

for.body:                                         ; No predecessors!
  br label %if.end

if.then.3:                                        ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %for.body, %if.then.3
  br label %for.inc

for.inc:                                          ; preds = %if.end
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %if.end.5

if.end.5:                                         ; preds = %entry, %for.end
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @Huniform_defaults() {
entry:
  store i64 2, i64* @hu_max_prims_cell, align 8
  store i64 5, i64* @hu_gridsize, align 8
  store i64 23, i64* @hu_numbuckets, align 8
  store i64 1, i64* @hu_max_subdiv_level, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @BuildHierarchy_Uniform() {
entry:
  %i = alloca i64, align 8
  %num = alloca i64, align 8
  %num_pe = alloca i64, align 8
  %status = alloca i64, align 8
  %den = alloca double, align 8
  %g = alloca %struct.grid*, align 8
  %gr = alloca %struct.grid*, align 8
  %ng = alloca %struct.grid*, align 8
  %testgrid = alloca %struct.grid, align 8
  %v = alloca %struct.voxel*, align 8
  %r = alloca %struct.ray, align 8
  %rinfo = alloca %struct.rayinfo*, align 8
  %pepa = alloca %struct.element**, align 8
  call void @init_masks()
  %call = call %struct.element** @MakeElementArray(i64* %num_pe)
  store %struct.element** %call, %struct.element*** %pepa, align 8
  %0 = load %struct.element*** %pepa, align 8
  %1 = load i64* %num_pe, align 8
  %call1 = call %struct.voxel* @init_world_voxel(%struct.element** %0, i64 %1)
  store %struct.voxel* %call1, %struct.voxel** %v, align 8
  %2 = load %struct.voxel** %v, align 8
  %3 = load %struct.element*** %pepa, align 8
  %4 = load i64* %num_pe, align 8
  %call2 = call %struct.grid* @init_world_grid(%struct.voxel* %2, %struct.element** %3, i64 %4)
  %5 = load %struct.gmem** @gm, align 8
  %world_level_grid = getelementptr inbounds %struct.gmem* %5, i32 0, i32 4
  store %struct.grid* %call2, %struct.grid** %world_level_grid, align 8
  %6 = load %struct.gmem** @gm, align 8
  %world_level_grid3 = getelementptr inbounds %struct.gmem* %6, i32 0, i32 4
  %7 = load %struct.grid** %world_level_grid3, align 8
  store %struct.grid* %7, %struct.grid** %g, align 8
  %8 = load %struct.voxel** %v, align 8
  %9 = load %struct.grid** %g, align 8
  %10 = load i64* %num_pe, align 8
  %call4 = call %struct.grid* @create_grid(%struct.voxel* %8, %struct.grid* %9, i64 %10)
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @IntersectHuniformPrimlist(i64* %intersectPrim, %struct.irecord* %hit, %struct.voxel* %v, %struct.ray* %r, i64 %pid) {
entry:
  %intersectPrim.addr = alloca i64*, align 8
  %hit.addr = alloca %struct.irecord*, align 8
  %v.addr = alloca %struct.voxel*, align 8
  %r.addr = alloca %struct.ray*, align 8
  %pid.addr = alloca i64, align 8
  %pptr = alloca %struct.element**, align 8
  %peParent = alloca %struct.object*, align 8
  %pe = alloca %struct.element*, align 8
  %newhit = alloca [2 x %struct.irecord], align 16
  %hitcode = alloca i64, align 8
  %i = alloca i64, align 8
  %t_out = alloca double, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br label %for.end

for.body:                                         ; No predecessors!
  br label %if.end.14

if.then:                                          ; No predecessors!
  br label %if.end

land.lhs.true:                                    ; No predecessors!
  br label %if.end

if.then.11:                                       ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %land.lhs.true, %if.then, %if.then.11
  br label %if.end.14

if.end.14:                                        ; preds = %for.body, %if.end
  br label %for.inc

for.inc:                                          ; preds = %if.end.14
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %if.end.19

if.then.18:                                       ; No predecessors!
  br label %if.end.19

if.else:                                          ; No predecessors!
  br label %if.end.19

if.end.19:                                        ; preds = %for.end, %if.else, %if.then.18
  ret void
}

; Function Attrs: nounwind uwtable
define internal double @HuniformShadowIntersect(%struct.ray* %r, double %lightlength, %struct.element* %pe, i64 %pid) {
entry:
  %retval = alloca double, align 8
  %r.addr = alloca %struct.ray*, align 8
  %lightlength.addr = alloca double, align 8
  %pe.addr = alloca %struct.element*, align 8
  %pid.addr = alloca i64, align 8
  %status = alloca i64, align 8
  %hitcode = alloca i64, align 8
  %i = alloca i64, align 8
  %trans = alloca double, align 8
  %peParent = alloca %struct.object*, align 8
  %pptr = alloca %struct.element**, align 8
  %pe2 = alloca %struct.element*, align 8
  %newhit = alloca [2 x %struct.irecord], align 16
  %v = alloca %struct.voxel*, align 8
  br label %return

if.then:                                          ; No predecessors!
  br label %return

if.end:                                           ; No predecessors!
  br label %while.cond

while.cond:                                       ; preds = %if.end.23, %if.end
  br label %land.end

land.rhs:                                         ; No predecessors!
  br label %land.end

land.end:                                         ; preds = %while.cond, %land.rhs
  br label %while.end

while.body:                                       ; No predecessors!
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %while.body
  br label %land.end.6

land.rhs.4:                                       ; No predecessors!
  br label %land.end.6

land.end.6:                                       ; preds = %for.cond, %land.rhs.4
  br label %for.end

for.body:                                         ; No predecessors!
  br label %if.end.19

land.lhs.true:                                    ; No predecessors!
  br label %if.end.19

land.lhs.true.11:                                 ; No predecessors!
  br label %if.end.19

if.then.15:                                       ; No predecessors!
  br label %if.end.19

if.end.19:                                        ; preds = %land.lhs.true.11, %land.lhs.true, %for.body, %if.then.15
  br label %for.inc

for.inc:                                          ; preds = %if.end.19
  br label %for.cond

for.end:                                          ; preds = %land.end.6
  br label %if.end.23

if.then.21:                                       ; No predecessors!
  br label %if.end.23

if.end.23:                                        ; preds = %for.end, %if.then.21
  br label %while.cond

while.end:                                        ; preds = %land.end
  br label %return

return:                                           ; preds = %entry, %while.end, %if.then
  ret double undef
}

; Function Attrs: nounwind uwtable
define internal i64 @TraverseHierarchyUniform(%struct.ray* %r, %struct.irecord* %hit, i64 %pid) {
entry:
  %retval = alloca i64, align 8
  %r.addr = alloca %struct.ray*, align 8
  %hit.addr = alloca %struct.irecord*, align 8
  %pid.addr = alloca i64, align 8
  %status = alloca i64, align 8
  %intersectPrim = alloca i64, align 8
  %v = alloca %struct.voxel*, align 8
  br label %return

if.then:                                          ; No predecessors!
  br label %return

if.end:                                           ; No predecessors!
  br label %while.cond

while.cond:                                       ; preds = %if.end.5, %if.end
  br label %land.end

land.rhs:                                         ; No predecessors!
  br label %land.end

land.end:                                         ; preds = %while.cond, %land.rhs
  br label %while.end

while.body:                                       ; No predecessors!
  br label %if.end.5

if.then.3:                                        ; No predecessors!
  br label %if.end.5

if.end.5:                                         ; preds = %while.body, %if.then.3
  br label %while.cond

while.end:                                        ; preds = %land.end
  br label %return

return:                                           ; preds = %entry, %while.end, %if.then
  ret i64 undef
}

; Function Attrs: nounwind uwtable
define internal void @prn_tv_stats() {
entry:
  ret void
}

; Function Attrs: nounwind uwtable
define internal i64 @send_ray(%struct.ray* %r, %struct.voxel* %v) {
entry:
  %retval = alloca i64, align 8
  %r.addr = alloca %struct.ray*, align 8
  %v.addr = alloca %struct.voxel*, align 8
  ret i64 undef
}

; Function Attrs: nounwind uwtable
define internal %struct.voxel* @lookup_hashtable(i64 %indx, %struct.grid* %g) {
entry:
  %indx.addr = alloca i64, align 8
  %g.addr = alloca %struct.grid*, align 8
  %i = alloca i64, align 8
  %v = alloca %struct.voxel*, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  br i1 undef, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  br i1 undef, label %if.then, label %if.end

if.then:                                          ; preds = %while.body
  unreachable

if.end:                                           ; preds = %while.body
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret %struct.voxel* undef
}

; Function Attrs: nounwind uwtable
define internal i64 @lookup_emptycells(i64 %indx, %struct.grid* %g) {
entry:
  %indx.addr = alloca i64, align 8
  %g.addr = alloca %struct.grid*, align 8
  %i = alloca i64, align 8
  %w = alloca i64, align 8
  %r = alloca i64, align 8
  %num_bits = alloca i64, align 8
  %p = alloca i64, align 8
  %b = alloca i64, align 8
  ret i64 undef
}

; Function Attrs: nounwind uwtable
define internal void @pop_up_a_grid(%struct.ray* %r) {
entry:
  %r.addr = alloca %struct.ray*, align 8
  %old_ri = alloca %struct.rayinfo*, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @push_down_grid(%struct.ray* %r, %struct.voxel* %v) {
entry:
  %r.addr = alloca %struct.ray*, align 8
  %v.addr = alloca %struct.voxel*, align 8
  %n = alloca i64, align 8
  %small = alloca i64, align 8
  %i_in = alloca i64, align 8
  %i_out = alloca i64, align 8
  %i = alloca i64, align 8
  %il = alloca i64, align 8
  %ih = alloca i64, align 8
  %wc = alloca [3 x double], align 16
  %ti = alloca double, align 8
  %del1 = alloca double, align 8
  %del2 = alloca double, align 8
  %t_in = alloca double, align 8
  %t_out = alloca double, align 8
  %tl = alloca double, align 8
  %th = alloca double, align 8
  %t = alloca [6 x double], align 16
  %min = alloca [3 x double], align 16
  %new_g = alloca %struct.grid*, align 8
  %new_ri = alloca %struct.rayinfo*, align 8
  %old_ri = alloca %struct.rayinfo*, align 8
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.else:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %entry, %if.else, %if.then
  br label %if.end.59

if.then.56:                                       ; No predecessors!
  br label %if.end.59

if.end.59:                                        ; preds = %if.end, %if.then.56
  br label %if.end.68

if.then.64:                                       ; No predecessors!
  br label %if.end.68

if.end.68:                                        ; preds = %if.end.59, %if.then.64
  br label %if.end.87

if.then.84:                                       ; No predecessors!
  br label %if.end.87

if.end.87:                                        ; preds = %if.end.68, %if.then.84
  br label %if.end.96

if.then.92:                                       ; No predecessors!
  br label %if.end.96

if.end.96:                                        ; preds = %if.end.87, %if.then.92
  br label %if.end.115

if.then.112:                                      ; No predecessors!
  br label %if.end.115

if.end.115:                                       ; preds = %if.end.96, %if.then.112
  br label %if.end.124

if.then.120:                                      ; No predecessors!
  br label %if.end.124

if.end.124:                                       ; preds = %if.end.115, %if.then.120
  switch i64 undef, label %sw.epilog [
    i64 3, label %sw.bb
    i64 0, label %sw.bb.153
    i64 4, label %sw.bb.220
    i64 1, label %sw.bb.222
    i64 5, label %sw.bb.295
    i64 2, label %sw.bb.297
    i64 -1, label %sw.bb.370
  ]

sw.bb:                                            ; preds = %if.end.124
  br label %sw.bb.153

sw.bb.153:                                        ; preds = %sw.bb, %if.end.124
  br label %if.end.180

if.then.168:                                      ; No predecessors!
  br label %if.end.180

if.else.175:                                      ; No predecessors!
  br label %if.end.180

if.end.180:                                       ; preds = %sw.bb.153, %if.else.175, %if.then.168
  br label %if.end.202

if.then.190:                                      ; No predecessors!
  br label %if.end.202

if.else.197:                                      ; No predecessors!
  br label %if.end.202

if.end.202:                                       ; preds = %if.end.180, %if.else.197, %if.then.190
  br label %cond.end

cond.true:                                        ; No predecessors!
  br label %cond.end

cond.false:                                       ; No predecessors!
  br label %cond.end

cond.end:                                         ; preds = %if.end.202, %cond.false, %cond.true
  br label %sw.epilog

sw.bb.220:                                        ; preds = %if.end.124
  br label %sw.bb.222

sw.bb.222:                                        ; preds = %sw.bb.220, %if.end.124
  br label %if.end.250

if.then.238:                                      ; No predecessors!
  br label %if.end.250

if.else.245:                                      ; No predecessors!
  br label %if.end.250

if.end.250:                                       ; preds = %sw.bb.222, %if.else.245, %if.then.238
  br label %if.end.272

if.then.260:                                      ; No predecessors!
  br label %if.end.272

if.else.267:                                      ; No predecessors!
  br label %if.end.272

if.end.272:                                       ; preds = %if.end.250, %if.else.267, %if.then.260
  br label %cond.end.289

cond.true.287:                                    ; No predecessors!
  br label %cond.end.289

cond.false.288:                                   ; No predecessors!
  br label %cond.end.289

cond.end.289:                                     ; preds = %if.end.272, %cond.false.288, %cond.true.287
  br label %sw.epilog

sw.bb.295:                                        ; preds = %if.end.124
  br label %sw.bb.297

sw.bb.297:                                        ; preds = %sw.bb.295, %if.end.124
  br label %if.end.325

if.then.313:                                      ; No predecessors!
  br label %if.end.325

if.else.320:                                      ; No predecessors!
  br label %if.end.325

if.end.325:                                       ; preds = %sw.bb.297, %if.else.320, %if.then.313
  br label %if.end.347

if.then.335:                                      ; No predecessors!
  br label %if.end.347

if.else.342:                                      ; No predecessors!
  br label %if.end.347

if.end.347:                                       ; preds = %if.end.325, %if.else.342, %if.then.335
  br label %cond.end.364

cond.true.362:                                    ; No predecessors!
  br label %cond.end.364

cond.false.363:                                   ; No predecessors!
  br label %cond.end.364

cond.end.364:                                     ; preds = %if.end.347, %cond.false.363, %cond.true.362
  br label %sw.epilog

sw.bb.370:                                        ; preds = %if.end.124
  br label %if.end.433

if.then.405:                                      ; No predecessors!
  br label %if.end.423

land.lhs.true:                                    ; No predecessors!
  br label %if.end.423

if.then.419:                                      ; No predecessors!
  br label %if.end.423

if.else.421:                                      ; No predecessors!
  br label %if.end.423

if.end.423:                                       ; preds = %land.lhs.true, %if.then.405, %if.else.421, %if.then.419
  br label %if.end.433

if.else.424:                                      ; No predecessors!
  br label %if.end.433

if.end.433:                                       ; preds = %sw.bb.370, %if.else.424, %if.end.423
  br label %if.end.467

if.then.438:                                      ; No predecessors!
  br label %if.end.457

land.lhs.true.444:                                ; No predecessors!
  br label %if.end.457

if.then.453:                                      ; No predecessors!
  br label %if.end.457

if.else.455:                                      ; No predecessors!
  br label %if.end.457

if.end.457:                                       ; preds = %land.lhs.true.444, %if.then.438, %if.else.455, %if.then.453
  br label %if.end.467

if.else.458:                                      ; No predecessors!
  br label %if.end.467

if.end.467:                                       ; preds = %if.end.433, %if.else.458, %if.end.457
  br label %if.end.501

if.then.472:                                      ; No predecessors!
  br label %if.end.491

land.lhs.true.478:                                ; No predecessors!
  br label %if.end.491

if.then.487:                                      ; No predecessors!
  br label %if.end.491

if.else.489:                                      ; No predecessors!
  br label %if.end.491

if.end.491:                                       ; preds = %land.lhs.true.478, %if.then.472, %if.else.489, %if.then.487
  br label %if.end.501

if.else.492:                                      ; No predecessors!
  br label %if.end.501

if.end.501:                                       ; preds = %if.end.467, %if.else.492, %if.end.491
  br label %if.end.538

if.then.506:                                      ; No predecessors!
  br label %if.end.525

land.lhs.true.512:                                ; No predecessors!
  br label %if.end.525

if.then.521:                                      ; No predecessors!
  br label %if.end.525

if.else.523:                                      ; No predecessors!
  br label %if.end.525

if.end.525:                                       ; preds = %land.lhs.true.512, %if.then.506, %if.else.523, %if.then.521
  br label %if.end.538

if.else.526:                                      ; No predecessors!
  br label %if.end.538

if.end.538:                                       ; preds = %if.end.501, %if.else.526, %if.end.525
  br label %if.end.575

if.then.543:                                      ; No predecessors!
  br label %if.end.562

land.lhs.true.549:                                ; No predecessors!
  br label %if.end.562

if.then.558:                                      ; No predecessors!
  br label %if.end.562

if.else.560:                                      ; No predecessors!
  br label %if.end.562

if.end.562:                                       ; preds = %land.lhs.true.549, %if.then.543, %if.else.560, %if.then.558
  br label %if.end.575

if.else.563:                                      ; No predecessors!
  br label %if.end.575

if.end.575:                                       ; preds = %if.end.538, %if.else.563, %if.end.562
  br label %if.end.612

if.then.580:                                      ; No predecessors!
  br label %if.end.599

land.lhs.true.586:                                ; No predecessors!
  br label %if.end.599

if.then.595:                                      ; No predecessors!
  br label %if.end.599

if.else.597:                                      ; No predecessors!
  br label %if.end.599

if.end.599:                                       ; preds = %land.lhs.true.586, %if.then.580, %if.else.597, %if.then.595
  br label %if.end.612

if.else.600:                                      ; No predecessors!
  br label %if.end.612

if.end.612:                                       ; preds = %if.end.575, %if.else.600, %if.end.599
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end.612
  br label %for.end

for.body:                                         ; No predecessors!
  br label %if.end.630

if.then.620:                                      ; No predecessors!
  br label %if.end.630

if.else.625:                                      ; No predecessors!
  br label %if.end.630

if.end.630:                                       ; preds = %for.body, %if.else.625, %if.then.620
  br label %if.end.636

if.then.635:                                      ; No predecessors!
  br label %if.end.636

if.end.636:                                       ; preds = %if.end.630, %if.then.635
  br label %if.end.640

if.then.639:                                      ; No predecessors!
  br label %if.end.640

if.end.640:                                       ; preds = %if.end.636, %if.then.639
  br label %for.inc

for.inc:                                          ; preds = %if.end.640
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br i1 undef, label %if.then.645, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %for.end
  br i1 undef, label %if.then.645, label %if.end.647

if.then.645:                                      ; preds = %lor.lhs.false, %for.end
  unreachable

if.end.647:                                       ; preds = %lor.lhs.false
  br label %if.end.652

if.then.650:                                      ; No predecessors!
  br label %if.end.652

if.end.652:                                       ; preds = %if.end.647, %if.then.650
  br label %if.end.657

if.then.655:                                      ; No predecessors!
  br label %if.end.657

if.end.657:                                       ; preds = %if.end.652, %if.then.655
  br label %sw.epilog

sw.epilog:                                        ; preds = %if.end.657, %cond.end.364, %cond.end.289, %cond.end, %if.end.124
  ret void
}

; Function Attrs: nounwind
declare double @fmod(double, double)

; Function Attrs: nounwind uwtable
define internal i64 @step_grid(%struct.ray* %r) {
entry:
  %retval = alloca i64, align 8
  %r.addr = alloca %struct.ray*, align 8
  %n = alloca i64, align 8
  %small = alloca i64, align 8
  %indx = alloca i64*, align 8
  %ra = alloca %struct.ray*, align 8
  %gr = alloca %struct.grid*, align 8
  %rinfo = alloca %struct.rayinfo*, align 8
  br label %return

lor.lhs.false:                                    ; No predecessors!
  br label %return

if.then:                                          ; No predecessors!
  br label %return

if.else:                                          ; No predecessors!
  br label %cond.end

cond.true:                                        ; No predecessors!
  br label %cond.end

cond.false:                                       ; No predecessors!
  br label %cond.end

cond.end:                                         ; preds = %if.else, %cond.false, %cond.true
  br label %return

return:                                           ; preds = %lor.lhs.false, %entry, %cond.end, %if.then
  ret i64 undef
}

; Function Attrs: nounwind uwtable
define internal i64 @next_voxel(%struct.ray* %r) {
entry:
  %retval = alloca i64, align 8
  %r.addr = alloca %struct.ray*, align 8
  %indx = alloca i64, align 8
  %gr = alloca %struct.grid*, align 8
  %v = alloca %struct.voxel*, align 8
  %rinfo = alloca %struct.rayinfo*, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  br label %return

while.body:                                       ; No predecessors!
  br label %return

if.then:                                          ; No predecessors!
  br label %if.end

if.else:                                          ; No predecessors!
  br label %return

if.end:                                           ; preds = %if.then
  br label %while.cond

while.end:                                        ; No predecessors!
  br label %return

return:                                           ; preds = %while.body, %while.cond, %while.end, %if.else
  ret i64 undef
}

; Function Attrs: nounwind uwtable
define internal %struct.voxel* @next_nonempty_voxel(%struct.ray* %r) {
entry:
  %retval = alloca %struct.voxel*, align 8
  %r.addr = alloca %struct.ray*, align 8
  %indx = alloca i64, align 8
  %v = alloca %struct.voxel*, align 8
  %gr = alloca %struct.grid*, align 8
  %rinfo = alloca %struct.rayinfo*, align 8
  br label %return

if.then:                                          ; No predecessors!
  br label %return

if.end:                                           ; No predecessors!
  br label %while.cond

while.cond:                                       ; preds = %if.end.6, %if.end
  br label %return

while.body:                                       ; No predecessors!
  br label %return

if.then.5:                                        ; No predecessors!
  br label %return

if.end.6:                                         ; No predecessors!
  br label %while.cond

while.end:                                        ; No predecessors!
  br label %return

return:                                           ; preds = %while.body, %while.cond, %entry, %while.end, %if.then.5, %if.then
  ret %struct.voxel* undef
}

; Function Attrs: nounwind uwtable
define internal %struct.voxel* @next_nonempty_leaf(%struct.ray* %r, i64 %step, i64* %status) {
entry:
  %retval = alloca %struct.voxel*, align 8
  %r.addr = alloca %struct.ray*, align 8
  %step.addr = alloca i64, align 8
  %status.addr = alloca i64*, align 8
  %indx = alloca i64, align 8
  %ng = alloca %struct.grid*, align 8
  %v = alloca %struct.voxel*, align 8
  %rinfo = alloca %struct.rayinfo*, align 8
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.else:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %entry, %if.else, %if.then
  br label %return

if.then.3:                                        ; No predecessors!
  br label %return

if.end.4:                                         ; No predecessors!
  br label %while.cond

while.cond:                                       ; preds = %if.end.46, %if.end.4
  br label %lor.end

lor.rhs:                                          ; No predecessors!
  br label %lor.end

lor.end:                                          ; preds = %while.cond, %lor.rhs
  br label %return

while.body:                                       ; No predecessors!
  br label %return

if.then.15:                                       ; No predecessors!
  br label %return

if.end.17:                                        ; No predecessors!
  br label %return

if.then.24:                                       ; No predecessors!
  br label %return

land.lhs.true:                                    ; No predecessors!
  br label %return

if.then.35:                                       ; No predecessors!
  br label %return

if.then.40:                                       ; No predecessors!
  br label %return

if.end.42:                                        ; No predecessors!
  br label %return

if.end.43:                                        ; No predecessors!
  br label %if.end.46

if.else.44:                                       ; No predecessors!
  br label %return

if.end.46:                                        ; preds = %if.end.43
  br label %while.cond

while.end:                                        ; No predecessors!
  br label %return

return:                                           ; preds = %if.then.35, %land.lhs.true, %if.then.24, %if.end.17, %while.body, %lor.end, %if.end, %while.end, %if.else.44, %if.end.42, %if.then.40, %if.then.15, %if.then.3
  ret %struct.voxel* undef
}

; Function Attrs: nounwind uwtable
define internal %struct.voxel* @init_ray(%struct.ray* %r, %struct.grid* %g) {
entry:
  %retval = alloca %struct.voxel*, align 8
  %r.addr = alloca %struct.ray*, align 8
  %g.addr = alloca %struct.grid*, align 8
  %status = alloca i64, align 8
  %indx = alloca i64, align 8
  %grid_id = alloca i64, align 8
  %i_in = alloca i64, align 8
  %i_out = alloca i64, align 8
  %i = alloca i64, align 8
  %il = alloca i64, align 8
  %ih = alloca i64, align 8
  %t_in = alloca double, align 8
  %t_out = alloca double, align 8
  %tl = alloca double, align 8
  %th = alloca double, align 8
  %t = alloca [6 x double], align 16
  %v = alloca %struct.voxel*, align 8
  %gr = alloca %struct.grid*, align 8
  %ri = alloca %struct.rayinfo*, align 8
  br label %if.end.21

if.then:                                          ; No predecessors!
  br label %if.end

land.lhs.true:                                    ; No predecessors!
  br label %if.end

if.then.10:                                       ; No predecessors!
  br label %if.end

if.else:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %land.lhs.true, %if.then, %if.else, %if.then.10
  br label %if.end.21

if.else.13:                                       ; No predecessors!
  br label %if.end.21

if.end.21:                                        ; preds = %entry, %if.else.13, %if.end
  br label %if.end.55

if.then.25:                                       ; No predecessors!
  br label %if.end.44

land.lhs.true.31:                                 ; No predecessors!
  br label %if.end.44

if.then.40:                                       ; No predecessors!
  br label %if.end.44

if.else.42:                                       ; No predecessors!
  br label %if.end.44

if.end.44:                                        ; preds = %land.lhs.true.31, %if.then.25, %if.else.42, %if.then.40
  br label %if.end.55

if.else.45:                                       ; No predecessors!
  br label %if.end.55

if.end.55:                                        ; preds = %if.end.21, %if.else.45, %if.end.44
  br label %if.end.89

if.then.59:                                       ; No predecessors!
  br label %if.end.78

land.lhs.true.65:                                 ; No predecessors!
  br label %if.end.78

if.then.74:                                       ; No predecessors!
  br label %if.end.78

if.else.76:                                       ; No predecessors!
  br label %if.end.78

if.end.78:                                        ; preds = %land.lhs.true.65, %if.then.59, %if.else.76, %if.then.74
  br label %if.end.89

if.else.79:                                       ; No predecessors!
  br label %if.end.89

if.end.89:                                        ; preds = %if.end.55, %if.else.79, %if.end.78
  br label %if.end.126

if.then.93:                                       ; No predecessors!
  br label %if.end.112

land.lhs.true.99:                                 ; No predecessors!
  br label %if.end.112

if.then.108:                                      ; No predecessors!
  br label %if.end.112

if.else.110:                                      ; No predecessors!
  br label %if.end.112

if.end.112:                                       ; preds = %land.lhs.true.99, %if.then.93, %if.else.110, %if.then.108
  br label %if.end.126

if.else.113:                                      ; No predecessors!
  br label %if.end.126

if.end.126:                                       ; preds = %if.end.89, %if.else.113, %if.end.112
  br label %if.end.163

if.then.130:                                      ; No predecessors!
  br label %if.end.149

land.lhs.true.136:                                ; No predecessors!
  br label %if.end.149

if.then.145:                                      ; No predecessors!
  br label %if.end.149

if.else.147:                                      ; No predecessors!
  br label %if.end.149

if.end.149:                                       ; preds = %land.lhs.true.136, %if.then.130, %if.else.147, %if.then.145
  br label %if.end.163

if.else.150:                                      ; No predecessors!
  br label %if.end.163

if.end.163:                                       ; preds = %if.end.126, %if.else.150, %if.end.149
  br label %if.end.200

if.then.167:                                      ; No predecessors!
  br label %if.end.186

land.lhs.true.173:                                ; No predecessors!
  br label %if.end.186

if.then.182:                                      ; No predecessors!
  br label %if.end.186

if.else.184:                                      ; No predecessors!
  br label %if.end.186

if.end.186:                                       ; preds = %land.lhs.true.173, %if.then.167, %if.else.184, %if.then.182
  br label %if.end.200

if.else.187:                                      ; No predecessors!
  br label %if.end.200

if.end.200:                                       ; preds = %if.end.163, %if.else.187, %if.end.186
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end.200
  br label %for.end

for.body:                                         ; No predecessors!
  br label %if.end.216

if.then.206:                                      ; No predecessors!
  br label %if.end.216

if.else.211:                                      ; No predecessors!
  br label %if.end.216

if.end.216:                                       ; preds = %for.body, %if.else.211, %if.then.206
  br label %if.end.219

if.then.218:                                      ; No predecessors!
  br label %if.end.219

if.end.219:                                       ; preds = %if.end.216, %if.then.218
  br label %if.end.222

if.then.221:                                      ; No predecessors!
  br label %if.end.222

if.end.222:                                       ; preds = %if.end.219, %if.then.221
  br label %for.inc

for.inc:                                          ; preds = %if.end.222
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %return

lor.lhs.false:                                    ; No predecessors!
  br label %return

if.then.225:                                      ; No predecessors!
  br label %return

if.end.226:                                       ; No predecessors!
  br label %if.end.238

if.then.231:                                      ; No predecessors!
  br label %if.end.238

if.else.234:                                      ; No predecessors!
  br label %if.end.238

if.end.238:                                       ; preds = %if.end.226, %if.else.234, %if.then.231
  br label %if.end.250

if.then.242:                                      ; No predecessors!
  br label %if.end.250

if.else.246:                                      ; No predecessors!
  br label %if.end.250

if.end.250:                                       ; preds = %if.end.238, %if.else.246, %if.then.242
  br label %if.end.262

if.then.254:                                      ; No predecessors!
  br label %if.end.262

if.else.258:                                      ; No predecessors!
  br label %if.end.262

if.end.262:                                       ; preds = %if.end.250, %if.else.258, %if.then.254
  br label %if.end.266

if.then.264:                                      ; No predecessors!
  br label %if.end.266

if.end.266:                                       ; preds = %if.end.262, %if.then.264
  br label %if.end.270

if.then.268:                                      ; No predecessors!
  br label %if.end.270

if.end.270:                                       ; preds = %if.end.266, %if.then.268
  br label %cond.end.289

cond.true:                                        ; No predecessors!
  br label %cond.end.289

cond.false:                                       ; No predecessors!
  br label %cond.end

cond.true.281:                                    ; No predecessors!
  br label %cond.end

cond.false.284:                                   ; No predecessors!
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.false.284, %cond.true.281
  br label %cond.end.289

cond.end.289:                                     ; preds = %if.end.270, %cond.end, %cond.true
  br label %cond.end.312

cond.true.295:                                    ; No predecessors!
  br label %cond.end.312

cond.false.296:                                   ; No predecessors!
  br label %cond.end.309

cond.true.302:                                    ; No predecessors!
  br label %cond.end.309

cond.false.305:                                   ; No predecessors!
  br label %cond.end.309

cond.end.309:                                     ; preds = %cond.false.296, %cond.false.305, %cond.true.302
  br label %cond.end.312

cond.end.312:                                     ; preds = %cond.end.289, %cond.end.309, %cond.true.295
  br label %cond.end.336

cond.true.319:                                    ; No predecessors!
  br label %cond.end.336

cond.false.320:                                   ; No predecessors!
  br label %cond.end.333

cond.true.326:                                    ; No predecessors!
  br label %cond.end.333

cond.false.329:                                   ; No predecessors!
  br label %cond.end.333

cond.end.333:                                     ; preds = %cond.false.320, %cond.false.329, %cond.true.326
  br label %cond.end.336

cond.end.336:                                     ; preds = %cond.end.312, %cond.end.333, %cond.true.319
  br label %return

if.then.392:                                      ; No predecessors!
  br label %if.end.397

if.else.396:                                      ; No predecessors!
  br label %return

if.end.397:                                       ; preds = %if.then.392
  br label %return

return:                                           ; preds = %cond.end.336, %lor.lhs.false, %for.end, %if.end.397, %if.else.396, %if.then.225
  ret %struct.voxel* undef
}

; Function Attrs: nounwind uwtable
define internal i64 @Intersect(%struct.ray* %pr, %struct.irecord* %hit) {
entry:
  %retval = alloca i64, align 8
  %pr.addr = alloca %struct.ray*, align 8
  %hit.addr = alloca %struct.irecord*, align 8
  %po = alloca %struct.object*, align 8
  %newhit = alloca %struct.irecord, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end.5, %entry
  br label %while.end

while.body:                                       ; No predecessors!
  br label %if.end.5

if.then:                                          ; No predecessors!
  br label %if.end

if.then.4:                                        ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %if.then, %if.then.4
  br label %if.end.5

if.end.5:                                         ; preds = %while.body, %if.end
  br label %while.cond

while.end:                                        ; preds = %while.cond
  br label %return

if.then.8:                                        ; No predecessors!
  br label %return

if.else:                                          ; No predecessors!
  br label %return

return:                                           ; preds = %while.end, %if.else, %if.then.8
  ret i64 undef
}

; Function Attrs: nounwind uwtable
define internal double @ShadowIntersect(%struct.ray* %pr, double %lightdist, %struct.element* %pe) {
entry:
  %pr.addr = alloca %struct.ray*, align 8
  %lightdist.addr = alloca double, align 8
  %pe.addr = alloca %struct.element*, align 8
  %trans = alloca double, align 8
  %po = alloca %struct.object*, align 8
  %newhit = alloca %struct.irecord, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  br label %land.end

land.rhs:                                         ; No predecessors!
  br label %land.end

land.end:                                         ; preds = %while.cond, %land.rhs
  br label %while.end

while.body:                                       ; No predecessors!
  br label %if.end

land.lhs.true:                                    ; No predecessors!
  br label %if.end

land.lhs.true.3:                                  ; No predecessors!
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %land.lhs.true.3, %land.lhs.true, %while.body, %if.then
  br label %while.cond

while.end:                                        ; preds = %land.end
  ret double undef
}

; Function Attrs: nounwind uwtable
define internal void @Usage() {
entry:
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @PrintStatistics() {
entry:
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %entry, %if.then
  ret void
}

; Function Attrs: nounwind uwtable
define internal i32 @atomic_cmpxchg(i32 %oldcount, i32 %newcount) {
entry:
  %oldcount.addr = alloca i32, align 4
  %newcount.addr = alloca i32, align 4
  %temp = alloca i32, align 4
  %updatedcount = alloca i32, align 4
  store i32 %oldcount, i32* %oldcount.addr, align 4
  store i32 %newcount, i32* %newcount.addr, align 4
  %0 = load %struct.gmem** @gm, align 8
  %start = getelementptr inbounds %struct.gmem* %0, i32 0, i32 8
  %count = getelementptr inbounds %struct.barrier_t* %start, i32 0, i32 1
  %1 = load volatile i64* %count, align 8
  %conv = trunc i64 %1 to i32
  store i32 %conv, i32* %temp, align 4
  %2 = load i32* %oldcount.addr, align 4
  %3 = load i32* %temp, align 4
  %cmp = icmp eq i32 %2, %3
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %4 = load i32* %newcount.addr, align 4
  %conv2 = sext i32 %4 to i64
  %5 = load %struct.gmem** @gm, align 8
  %start3 = getelementptr inbounds %struct.gmem* %5, i32 0, i32 8
  %count4 = getelementptr inbounds %struct.barrier_t* %start3, i32 0, i32 1
  call void @RecordSyncVariable()
  store volatile i64 %conv2, i64* %count4, align 8
  call void @snapshot64(i64 %conv2, i32 0)
  %6 = load i32* %oldcount.addr, align 4
  store i32 %6, i32* %updatedcount, align 4
  br label %if.end

if.else:                                          ; preds = %entry
  %7 = load %struct.gmem** @gm, align 8
  %start5 = getelementptr inbounds %struct.gmem* %7, i32 0, i32 8
  %count6 = getelementptr inbounds %struct.barrier_t* %start5, i32 0, i32 1
  %8 = load volatile i64* %count6, align 8
  %conv7 = trunc i64 %8 to i32
  store i32 %conv7, i32* %updatedcount, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %9 = load i32* %updatedcount, align 4
  ret i32 %9
}

; Function Attrs: nounwind uwtable
define internal void @StartRayTrace() {
entry:
  %pid = alloca i64, align 8
  %begin = alloca i64, align 8
  %end = alloca i64, align 8
  %lapsed = alloca i64, align 8
  %lsense = alloca i32, align 4
  %oldcount = alloca i32, align 4
  %newcount = alloca i32, align 4
  %updatedcount = alloca i32, align 4
  %retVal = alloca i32, align 4
  %0 = load %struct.gmem** @gm, align 8
  %pid1 = getelementptr inbounds %struct.gmem* %0, i32 0, i32 1
  %1 = load i64* %pid1, align 8
  %inc = add nsw i64 %1, 1
  store i64 %inc, i64* %pid1, align 8
  store i64 %1, i64* %pid, align 8
  br label %if.end

lor.lhs.false:                                    ; No predecessors!
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %lor.lhs.false, %entry, %if.then
  %2 = load i64* %pid, align 8
  call void @InitWorkPool(i64 %2)
  %3 = load %struct.gmem** @gm, align 8
  %start = getelementptr inbounds %struct.gmem* %3, i32 0, i32 8
  %gsense = getelementptr inbounds %struct.barrier_t* %start, i32 0, i32 0
  call void @InitializeSwitchesAndCounter(i32 1)
  call void @IncrementCounter()
  call void @printChar(i8 signext 49)
  call void @printChar(i8 signext 90)
  %4 = load volatile i32* %gsense, align 4
  store i32 %4, i32* %lsense, align 4
  br label %while.body

while.body:                                       ; preds = %if.end.25, %if.end
  %5 = load %struct.gmem** @gm, align 8
  %start5 = getelementptr inbounds %struct.gmem* %5, i32 0, i32 8
  %count = getelementptr inbounds %struct.barrier_t* %start5, i32 0, i32 1
  %6 = load volatile i64* %count, align 8
  %call = call i32 @sleep(i32 1)
  %conv = trunc i64 %6 to i32
  store i32 %conv, i32* %oldcount, align 4
  %7 = load i32* %oldcount, align 4
  %8 = load i32* %lsense, align 4
  %add = add nsw i32 %7, %8
  store i32 %add, i32* %newcount, align 4
  %9 = load i32* %oldcount, align 4
  %10 = load i32* %newcount, align 4
  %call6 = call i32 @atomic_cmpxchg(i32 %9, i32 %10)
  %call5 = call i32 @sleep(i32 1)
  store i32 %call6, i32* %updatedcount, align 4
  %11 = load i32* %updatedcount, align 4
  %12 = load i32* %oldcount, align 4
  %cmp7 = icmp eq i32 %11, %12
  br i1 %cmp7, label %if.then.9, label %if.end.25

if.then.9:                                        ; preds = %while.body
  %13 = load i32* %newcount, align 4
  %conv10 = sext i32 %13 to i64
  %14 = load %struct.gmem** @gm, align 8
  %nprocs = getelementptr inbounds %struct.gmem* %14, i32 0, i32 0
  %15 = load i64* %nprocs, align 8
  %call1 = call i32 @sleep(i32 1)
  %cmp11 = icmp eq i64 %conv10, %15
  br i1 %cmp11, label %land.lhs.true, label %lor.lhs.false.15

land.lhs.true:                                    ; preds = %if.then.9
  %16 = load i32* %lsense, align 4
  %cmp13 = icmp eq i32 %16, 1
  br i1 %cmp13, label %if.then.21, label %lor.lhs.false.15

lor.lhs.false.15:                                 ; preds = %land.lhs.true, %if.then.9
  %17 = load i32* %newcount, align 4
  %cmp16 = icmp eq i32 %17, 0
  br i1 %cmp16, label %land.lhs.true.18, label %if.end.24

land.lhs.true.18:                                 ; preds = %lor.lhs.false.15
  %18 = load i32* %lsense, align 4
  %cmp19 = icmp eq i32 %18, -1
  br i1 %cmp19, label %if.then.21, label %if.end.24

if.then.21:                                       ; preds = %land.lhs.true.18, %land.lhs.true
  %19 = load i32* %lsense, align 4
  %sub = sub nsw i32 0, %19
  %20 = load %struct.gmem** @gm, align 8
  %start22 = getelementptr inbounds %struct.gmem* %20, i32 0, i32 8
  %gsense23 = getelementptr inbounds %struct.barrier_t* %start22, i32 0, i32 0
  call void @printX()
  call void @RecordSyncVariable()
  store volatile i32 %sub, i32* %gsense23, align 4
  call void @snapshot(i32 %sub, i32 1)
  %call2 = call i32 @sleep(i32 3)
  br label %if.end.24

if.end.24:                                        ; preds = %if.then.21, %land.lhs.true.18, %lor.lhs.false.15
  br label %while.end

if.end.25:                                        ; preds = %while.body
  br label %while.body

while.end:                                        ; preds = %if.end.24
  br label %while.cond

while.cond:                                       ; preds = %while.body.30, %while.end
  %21 = load %struct.gmem** @gm, align 8
  %start26 = getelementptr inbounds %struct.gmem* %21, i32 0, i32 8
  %gsense27 = getelementptr inbounds %struct.barrier_t* %start26, i32 0, i32 0
  %22 = load volatile i32* %gsense27, align 4
  %23 = load i32* %lsense, align 4
  %cmp28 = icmp eq i32 %22, %23
  br i1 %cmp28, label %while.body.30, label %while.end.31

while.body.30:                                    ; preds = %while.cond
  %call3 = call i32 @sleep(i32 2)
  br label %while.cond

while.end.31:                                     ; preds = %while.cond
  call void @printY()
  %call4 = call i32 @sleep(i32 4)
  br label %if.end.43

lor.lhs.false.34:                                 ; No predecessors!
  br label %if.end.43

if.then.36:                                       ; No predecessors!
  br label %if.end.42

if.then.41:                                       ; No predecessors!
  br label %if.end.42

if.end.42:                                        ; preds = %if.then.36, %if.then.41
  br label %if.end.43

if.end.43:                                        ; preds = %lor.lhs.false.34, %while.end.31, %if.end.42
  ret void
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t*)

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t*)

; Function Attrs: nounwind
declare i64 @time(i64*)

declare void @Criteria(i32)

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %i = alloca i64, align 8
  %begin = alloca i64, align 8
  %end = alloca i64, align 8
  %lapsed = alloca i64, align 8
  %tmp = alloca i16, align 2
  %pch = alloca i8*, align 8
  %vtrans = alloca [4 x [4 x double]], align 16
  %Vinv = alloca [4 x [4 x double]], align 16
  %i56 = alloca i32, align 4
  %t = alloca i64, align 8
  %totalproctime = alloca i32, align 4
  %maxproctime = alloca i32, align 4
  %minproctime = alloca i32, align 4
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 8
  br label %while.cond

while.cond:                                       ; preds = %for.end, %entry
  %0 = load i32* %argc.addr, align 4
  %dec = add nsw i32 %0, -1
  store i32 %dec, i32* %argc.addr, align 4
  %cmp = icmp sgt i32 %0, 1
  br i1 %cmp, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %while.cond
  %1 = load i8*** %argv.addr, align 8
  %incdec.ptr = getelementptr inbounds i8** %1, i32 1
  store i8** %incdec.ptr, i8*** %argv.addr, align 8
  %2 = load i8** %incdec.ptr, align 8
  %arrayidx = getelementptr inbounds i8* %2, i64 0
  %3 = load i8* %arrayidx, align 1
  %conv = sext i8 %3 to i32
  %cmp4 = icmp eq i32 %conv, 45
  br label %land.end

land.end:                                         ; preds = %land.rhs, %while.cond
  %4 = phi i1 [ false, %while.cond ], [ %cmp4, %land.rhs ]
  br i1 %4, label %while.body, label %while.end

while.body:                                       ; preds = %land.end
  %5 = load i8*** %argv.addr, align 8
  %arrayidx6 = getelementptr inbounds i8** %5, i64 0
  %6 = load i8** %arrayidx6, align 8
  %add.ptr = getelementptr inbounds i8* %6, i64 1
  store i8* %add.ptr, i8** %pch, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %while.body
  %7 = load i8** %pch, align 8
  %8 = load i8* %7, align 1
  %conv7 = sext i8 %8 to i32
  %cmp8 = icmp ne i32 %conv7, 0
  br i1 %cmp8, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %9 = load i8** %pch, align 8
  %10 = load i8* %9, align 1
  %conv10 = sext i8 %10 to i32
  switch i32 %conv10, label %sw.default [
    i32 63, label %sw.bb
    i32 104, label %sw.bb
    i32 72, label %sw.bb
    i32 97, label %sw.bb.11
    i32 65, label %sw.bb.11
    i32 109, label %sw.bb.15
    i32 112, label %sw.bb.23
    i32 115, label %sw.bb.31
    i32 83, label %sw.bb.31
  ]

sw.bb:                                            ; preds = %for.body, %for.body, %for.body
  br label %UnifiedUnreachableBlock

sw.bb.11:                                         ; preds = %for.body, %for.body
  %11 = load i8** %pch, align 8
  %incdec.ptr12 = getelementptr inbounds i8* %11, i32 1
  store i8* %incdec.ptr12, i8** %pch, align 8
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %sw.bb.11, %if.then
  %12 = load i8** %pch, align 8
  %incdec.ptr14 = getelementptr inbounds i8* %12, i32 -1
  store i8* %incdec.ptr14, i8** %pch, align 8
  br label %sw.epilog

sw.bb.15:                                         ; preds = %for.body
  %13 = load i8** %pch, align 8
  %incdec.ptr16 = getelementptr inbounds i8* %13, i32 1
  store i8* %incdec.ptr16, i8** %pch, align 8
  %14 = load i8* %incdec.ptr16, align 1
  %tobool17 = icmp ne i8 %14, 0
  br i1 %tobool17, label %if.then.18, label %if.end.21

if.then.18:                                       ; preds = %sw.bb.15
  %15 = load i8** %pch, align 8
  %call19 = call i32 (i8*, ...) *bitcast (i32 (...)* @atoi to i32 (i8*, ...)*)(i8* %15)
  %conv20 = sext i32 %call19 to i64
  store i64 %conv20, i64* @MaxGlobMem, align 8
  br label %if.end.21

if.end.21:                                        ; preds = %if.then.18, %sw.bb.15
  %16 = load i8** %pch, align 8
  %incdec.ptr22 = getelementptr inbounds i8* %16, i32 -1
  store i8* %incdec.ptr22, i8** %pch, align 8
  br label %sw.epilog

sw.bb.23:                                         ; preds = %for.body
  %17 = load i8** %pch, align 8
  %incdec.ptr24 = getelementptr inbounds i8* %17, i32 1
  store i8* %incdec.ptr24, i8** %pch, align 8
  %18 = load i8* %incdec.ptr24, align 1
  %tobool25 = icmp ne i8 %18, 0
  br i1 %tobool25, label %if.then.26, label %if.end.29

if.then.26:                                       ; preds = %sw.bb.23
  %19 = load i8** %pch, align 8
  %call27 = call i32 (i8*, ...) *bitcast (i32 (...)* @atoi to i32 (i8*, ...)*)(i8* %19)
  %conv28 = sext i32 %call27 to i64
  store i64 %conv28, i64* @nprocs, align 8
  br label %if.end.29

if.end.29:                                        ; preds = %if.then.26, %sw.bb.23
  %20 = load i8** %pch, align 8
  %incdec.ptr30 = getelementptr inbounds i8* %20, i32 -1
  store i8* %incdec.ptr30, i8** %pch, align 8
  br label %sw.epilog

sw.bb.31:                                         ; preds = %for.body, %for.body
  br label %sw.epilog

sw.default:                                       ; preds = %for.body
  br label %UnifiedUnreachableBlock

sw.epilog:                                        ; preds = %sw.bb.31, %if.end.29, %if.end.21, %if.end
  br label %for.inc

for.inc:                                          ; preds = %sw.epilog
  %21 = load i8** %pch, align 8
  %incdec.ptr34 = getelementptr inbounds i8* %21, i32 1
  store i8* %incdec.ptr34, i8** %pch, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %while.cond

while.end:                                        ; preds = %land.end
  %22 = load i32* %argc.addr, align 4
  %tobool35 = icmp ne i32 %22, 0
  br i1 %tobool35, label %if.end.37, label %if.then.36

if.then.36:                                       ; preds = %while.end
  br label %UnifiedUnreachableBlock

if.end.37:                                        ; preds = %while.end
  %23 = load i64* @nprocs, align 8
  %cmp38 = icmp slt i64 %23, 1
  br i1 %cmp38, label %if.then.42, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %if.end.37
  %24 = load i64* @nprocs, align 8
  %cmp40 = icmp sgt i64 %24, 128
  br i1 %cmp40, label %if.then.42, label %if.end.44

if.then.42:                                       ; preds = %lor.lhs.false, %if.end.37
  br label %UnifiedUnreachableBlock

if.end.44:                                        ; preds = %lor.lhs.false
  %25 = load i64* @MaxGlobMem, align 8
  %shl = shl i64 %25, 20
  store i64 %shl, i64* @MaxGlobMem, align 8
  %call50 = call i8* @malloc(i64 530624)
  %26 = bitcast i8* %call50 to %struct.gmem*
  store %struct.gmem* %26, %struct.gmem** @gm, align 8
  %27 = load i64* @nprocs, align 8
  %28 = load %struct.gmem** @gm, align 8
  %nprocs = getelementptr inbounds %struct.gmem* %28, i32 0, i32 0
  store i64 %27, i64* %nprocs, align 8
  %29 = load %struct.gmem** @gm, align 8
  %pid = getelementptr inbounds %struct.gmem* %29, i32 0, i32 1
  store i64 0, i64* %pid, align 8
  %30 = load %struct.gmem** @gm, align 8
  %start = getelementptr inbounds %struct.gmem* %30, i32 0, i32 8
  %gsense = getelementptr inbounds %struct.barrier_t* %start, i32 0, i32 0
  store volatile i32 1, i32* %gsense, align 4
  %31 = load %struct.gmem** @gm, align 8
  %start51 = getelementptr inbounds %struct.gmem* %31, i32 0, i32 8
  %count = getelementptr inbounds %struct.barrier_t* %start51, i32 0, i32 1
  store volatile i64 0, i64* %count, align 8
  br label %for.cond.57

for.cond.57:                                      ; preds = %for.inc.64, %if.end.44
  br label %for.end.65

for.body.61:                                      ; No predecessors!
  br label %for.inc.64

for.inc.64:                                       ; preds = %for.body.61
  br label %for.cond.57

for.end.65:                                       ; preds = %for.cond.57
  %32 = load i64* @MaxGlobMem, align 8
  %call66 = call i64 @GlobalHeapInit(i64 %32)
  %tobool67 = icmp ne i64 %call66, 0
  br i1 %tobool67, label %if.end.70, label %if.then.68

if.then.68:                                       ; preds = %for.end.65
  br label %UnifiedUnreachableBlock

if.end.70:                                        ; preds = %for.end.65
  call void @Huniform_defaults()
  %33 = load i8*** %argv.addr, align 8
  %34 = load i8** %33, align 8
  call void @ReadEnvFile(i8* %34)
  call void @OpenFrameBuffer()
  call void @CreateViewMatrix()
  %arraydecay = getelementptr inbounds [4 x [4 x double]]* %vtrans, i32 0, i32 0
  call void @MatrixCopy([4 x double]* %arraydecay, [4 x double]* getelementptr inbounds (%struct.view* @View, i32 0, i32 2, i32 0))
  %arraydecay71 = getelementptr inbounds [4 x [4 x double]]* %Vinv, i32 0, i32 0
  %arraydecay72 = getelementptr inbounds [4 x [4 x double]]* %vtrans, i32 0, i32 0
  call void @MatrixInverse([4 x double]* %arraydecay71, [4 x double]* %arraydecay72)
  %arraydecay73 = getelementptr inbounds [4 x [4 x double]]* %Vinv, i32 0, i32 0
  call void @MatrixCopy([4 x double]* getelementptr inbounds (%struct.view* @View, i32 0, i32 3, i32 0), [4 x double]* %arraydecay73)
  br label %if.end.80

if.then.78:                                       ; No predecessors!
  br label %if.end.80

if.end.80:                                        ; preds = %if.end.70, %if.then.78
  store i64 0, i64* %i, align 8
  br label %for.cond.81

for.cond.81:                                      ; preds = %for.inc.88, %if.end.80
  %35 = load i64* %i, align 8
  %36 = load %struct.gmem** @gm, align 8
  %nprocs82 = getelementptr inbounds %struct.gmem* %36, i32 0, i32 0
  store i64 2, i64* %nprocs82
  %37 = load i64* %nprocs82, align 8
  %sub = sub nsw i64 %37, 1
  %cmp83 = icmp slt i64 %35, %sub
  br i1 %cmp83, label %for.body.85, label %for.end.90

for.body.85:                                      ; preds = %for.cond.81
  %call87 = call i32 @pthread_create(i64* %t, %union.pthread_attr_t* null, i8* (i8*)* bitcast (void ()* @StartRayTrace to i8* (i8*)*), i8* null)
  br label %for.inc.88

for.inc.88:                                       ; preds = %for.body.85
  %38 = load i64* %i, align 8
  %inc89 = add nsw i64 %38, 1
  store i64 %inc89, i64* %i, align 8
  br label %for.cond.81

for.end.90:                                       ; preds = %for.cond.81
  call void @StartRayTrace()
  br label %if.end.165

if.then.100:                                      ; No predecessors!
  br label %for.cond.107

for.cond.107:                                     ; preds = %for.inc.114, %if.then.100
  br label %for.end.116

for.body.111:                                     ; No predecessors!
  br label %for.inc.114

for.inc.114:                                      ; preds = %for.body.111
  br label %for.cond.107

for.end.116:                                      ; preds = %for.cond.107
  br label %for.cond.126

for.cond.126:                                     ; preds = %for.inc.155, %for.end.116
  br label %for.end.157

for.body.130:                                     ; No predecessors!
  br label %if.end.144

if.then.140:                                      ; No predecessors!
  br label %if.end.144

if.end.144:                                       ; preds = %for.body.130, %if.then.140
  br label %if.end.154

if.then.150:                                      ; No predecessors!
  br label %if.end.154

if.end.154:                                       ; preds = %if.end.144, %if.then.150
  br label %for.inc.155

for.inc.155:                                      ; preds = %if.end.154
  br label %for.cond.126

for.end.157:                                      ; preds = %for.cond.126
  br label %if.end.165

if.end.165:                                       ; preds = %for.end.90, %for.end.157
  br label %UnifiedUnreachableBlock

return:                                           ; No predecessors!
  call void @waitForAll()
  ret i32 undef

UnifiedUnreachableBlock:                          ; preds = %if.end.165, %if.then.68, %if.then.42, %if.then.36, %sw.default, %sw.bb
  call void @waitForAll()
  call void @waitForAll()
  unreachable
}

declare i32 @atoi(...)

declare i8* @malloc(i64)

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t*, %union.pthread_mutexattr_t*)

; Function Attrs: nounwind
declare i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*)

; Function Attrs: nounwind uwtable
define internal void @VecNorm(double* %V) {
entry:
  %V.addr = alloca double*, align 8
  %l = alloca double, align 8
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %entry, %if.then
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @VecMatMult(double* %Vt, [4 x double]* %M, double* %V) {
entry:
  %Vt.addr = alloca double*, align 8
  %M.addr = alloca [4 x double]*, align 8
  %V.addr = alloca double*, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %tvec = alloca [4 x double], align 16
  br label %for.cond

for.cond:                                         ; preds = %for.inc.8, %entry
  br label %for.end.10

for.body:                                         ; No predecessors!
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc, %for.body
  br label %for.end

for.body.3:                                       ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body.3
  br label %for.cond.1

for.end:                                          ; preds = %for.cond.1
  br label %for.inc.8

for.inc.8:                                        ; preds = %for.end
  br label %for.cond

for.end.10:                                       ; preds = %for.cond
  br label %for.cond.11

for.cond.11:                                      ; preds = %for.inc.16, %for.end.10
  br label %for.end.18

for.body.13:                                      ; No predecessors!
  br label %for.inc.16

for.inc.16:                                       ; preds = %for.body.13
  br label %for.cond.11

for.end.18:                                       ; preds = %for.cond.11
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @PrintMatrix([4 x double]* %M, i8* %s) {
entry:
  %M.addr = alloca [4 x double]*, align 8
  %s.addr = alloca i8*, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc.8, %entry
  br label %for.end.10

for.body:                                         ; No predecessors!
  br label %for.cond.2

for.cond.2:                                       ; preds = %for.inc, %for.body
  br label %for.end

for.body.4:                                       ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body.4
  br label %for.cond.2

for.end:                                          ; preds = %for.cond.2
  br label %for.inc.8

for.inc.8:                                        ; preds = %for.end
  br label %for.cond

for.end.10:                                       ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @MatrixIdentity([4 x double]* %M) {
entry:
  %M.addr = alloca [4 x double]*, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  store [4 x double]* %M, [4 x double]** %M.addr, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc.5, %entry
  br label %for.end.7

for.body:                                         ; No predecessors!
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc, %for.body
  br label %for.end

for.body.3:                                       ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body.3
  br label %for.cond.1

for.end:                                          ; preds = %for.cond.1
  br label %for.inc.5

for.inc.5:                                        ; preds = %for.end
  br label %for.cond

for.end.7:                                        ; preds = %for.cond
  %0 = load [4 x double]** %M.addr, align 8
  %arrayidx8 = getelementptr inbounds [4 x double]* %0, i64 0
  %arrayidx9 = getelementptr inbounds [4 x double]* %arrayidx8, i32 0, i64 0
  store double 1.000000e+00, double* %arrayidx9, align 8
  %1 = load [4 x double]** %M.addr, align 8
  %arrayidx10 = getelementptr inbounds [4 x double]* %1, i64 1
  %arrayidx11 = getelementptr inbounds [4 x double]* %arrayidx10, i32 0, i64 1
  store double 1.000000e+00, double* %arrayidx11, align 8
  %2 = load [4 x double]** %M.addr, align 8
  %arrayidx14 = getelementptr inbounds [4 x double]* %2, i64 3
  %arrayidx15 = getelementptr inbounds [4 x double]* %arrayidx14, i32 0, i64 3
  store double 1.000000e+00, double* %arrayidx15, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @MatrixCopy([4 x double]* %A, [4 x double]* %B) {
entry:
  %A.addr = alloca [4 x double]*, align 8
  %B.addr = alloca [4 x double]*, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  store [4 x double]* %A, [4 x double]** %A.addr, align 8
  store [4 x double]* %B, [4 x double]** %B.addr, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc.7, %entry
  %0 = load i64* %i, align 8
  %cmp = icmp slt i64 %0, 4
  br i1 %cmp, label %for.body, label %for.end.9

for.body:                                         ; preds = %for.cond
  store i64 0, i64* %j, align 8
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc, %for.body
  %1 = load i64* %j, align 8
  %cmp2 = icmp slt i64 %1, 4
  br i1 %cmp2, label %for.body.3, label %for.end

for.body.3:                                       ; preds = %for.cond.1
  %2 = load i64* %j, align 8
  %3 = load i64* %i, align 8
  %4 = load [4 x double]** %B.addr, align 8
  %arrayidx = getelementptr inbounds [4 x double]* %4, i64 %3
  %arrayidx4 = getelementptr inbounds [4 x double]* %arrayidx, i32 0, i64 %2
  %5 = load double* %arrayidx4, align 8
  %6 = load i64* %j, align 8
  %7 = load i64* %i, align 8
  %8 = load [4 x double]** %A.addr, align 8
  %arrayidx5 = getelementptr inbounds [4 x double]* %8, i64 %7
  %arrayidx6 = getelementptr inbounds [4 x double]* %arrayidx5, i32 0, i64 %6
  store double %5, double* %arrayidx6, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body.3
  %9 = load i64* %j, align 8
  %inc = add nsw i64 %9, 1
  store i64 %inc, i64* %j, align 8
  br label %for.cond.1

for.end:                                          ; preds = %for.cond.1
  br label %for.inc.7

for.inc.7:                                        ; preds = %for.end
  %10 = load i64* %i, align 8
  %inc8 = add nsw i64 %10, 1
  store i64 %inc8, i64* %i, align 8
  br label %for.cond

for.end.9:                                        ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @MatrixTranspose([4 x double]* %MT, [4 x double]* %M) {
entry:
  %MT.addr = alloca [4 x double]*, align 8
  %M.addr = alloca [4 x double]*, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %tmp = alloca [4 x [4 x double]], align 16
  store [4 x double]* %MT, [4 x double]** %MT.addr, align 8
  store [4 x double]* %M, [4 x double]** %M.addr, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc.7, %entry
  %0 = load i64* %i, align 8
  %cmp = icmp slt i64 %0, 4
  br i1 %cmp, label %for.body, label %for.end.9

for.body:                                         ; preds = %for.cond
  store i64 0, i64* %j, align 8
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc, %for.body
  %1 = load i64* %j, align 8
  %cmp2 = icmp slt i64 %1, 4
  br i1 %cmp2, label %for.body.3, label %for.end

for.body.3:                                       ; preds = %for.cond.1
  %2 = load i64* %j, align 8
  %3 = load i64* %i, align 8
  %4 = load [4 x double]** %M.addr, align 8
  %arrayidx = getelementptr inbounds [4 x double]* %4, i64 %3
  %arrayidx4 = getelementptr inbounds [4 x double]* %arrayidx, i32 0, i64 %2
  %5 = load double* %arrayidx4, align 8
  %6 = load i64* %i, align 8
  %7 = load i64* %j, align 8
  %arrayidx5 = getelementptr inbounds [4 x [4 x double]]* %tmp, i32 0, i64 %7
  %arrayidx6 = getelementptr inbounds [4 x double]* %arrayidx5, i32 0, i64 %6
  store double %5, double* %arrayidx6, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body.3
  %8 = load i64* %j, align 8
  %inc = add nsw i64 %8, 1
  store i64 %inc, i64* %j, align 8
  br label %for.cond.1

for.end:                                          ; preds = %for.cond.1
  br label %for.inc.7

for.inc.7:                                        ; preds = %for.end
  %9 = load i64* %i, align 8
  %inc8 = add nsw i64 %9, 1
  store i64 %inc8, i64* %i, align 8
  br label %for.cond

for.end.9:                                        ; preds = %for.cond
  %10 = load [4 x double]** %MT.addr, align 8
  %arraydecay = getelementptr inbounds [4 x [4 x double]]* %tmp, i32 0, i32 0
  call void @MatrixCopy([4 x double]* %10, [4 x double]* %arraydecay)
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @MatrixMult([4 x double]* %C, [4 x double]* %A, [4 x double]* %B) {
entry:
  %C.addr = alloca [4 x double]*, align 8
  %A.addr = alloca [4 x double]*, align 8
  %B.addr = alloca [4 x double]*, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %k = alloca i64, align 8
  %T = alloca [4 x [4 x double]], align 16
  store [4 x double]* %C, [4 x double]** %C.addr, align 8
  store [4 x double]* %A, [4 x double]** %A.addr, align 8
  store [4 x double]* %B, [4 x double]** %B.addr, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc.17, %entry
  %0 = load i64* %i, align 8
  %cmp = icmp slt i64 %0, 4
  br i1 %cmp, label %for.body, label %for.end.19

for.body:                                         ; preds = %for.cond
  store i64 0, i64* %j, align 8
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc.14, %for.body
  %1 = load i64* %j, align 8
  %cmp2 = icmp slt i64 %1, 4
  br i1 %cmp2, label %for.body.3, label %for.end.16

for.body.3:                                       ; preds = %for.cond.1
  %2 = load i64* %j, align 8
  %3 = load i64* %i, align 8
  %arrayidx = getelementptr inbounds [4 x [4 x double]]* %T, i32 0, i64 %3
  %arrayidx4 = getelementptr inbounds [4 x double]* %arrayidx, i32 0, i64 %2
  store double 0.000000e+00, double* %arrayidx4, align 8
  store i64 0, i64* %k, align 8
  br label %for.cond.5

for.cond.5:                                       ; preds = %for.inc, %for.body.3
  %4 = load i64* %k, align 8
  %cmp6 = icmp slt i64 %4, 4
  br i1 %cmp6, label %for.body.7, label %for.end

for.body.7:                                       ; preds = %for.cond.5
  %5 = load i64* %k, align 8
  %6 = load i64* %i, align 8
  %7 = load [4 x double]** %A.addr, align 8
  %arrayidx8 = getelementptr inbounds [4 x double]* %7, i64 %6
  %arrayidx9 = getelementptr inbounds [4 x double]* %arrayidx8, i32 0, i64 %5
  %8 = load double* %arrayidx9, align 8
  %9 = load i64* %j, align 8
  %10 = load i64* %k, align 8
  %11 = load [4 x double]** %B.addr, align 8
  %arrayidx10 = getelementptr inbounds [4 x double]* %11, i64 %10
  %arrayidx11 = getelementptr inbounds [4 x double]* %arrayidx10, i32 0, i64 %9
  %12 = load double* %arrayidx11, align 8
  %mul = fmul double %8, %12
  %13 = load i64* %j, align 8
  %14 = load i64* %i, align 8
  %arrayidx12 = getelementptr inbounds [4 x [4 x double]]* %T, i32 0, i64 %14
  %arrayidx13 = getelementptr inbounds [4 x double]* %arrayidx12, i32 0, i64 %13
  %15 = load double* %arrayidx13, align 8
  %add = fadd double %15, %mul
  store double %add, double* %arrayidx13, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body.7
  %16 = load i64* %k, align 8
  %inc = add nsw i64 %16, 1
  store i64 %inc, i64* %k, align 8
  br label %for.cond.5

for.end:                                          ; preds = %for.cond.5
  br label %for.inc.14

for.inc.14:                                       ; preds = %for.end
  %17 = load i64* %j, align 8
  %inc15 = add nsw i64 %17, 1
  store i64 %inc15, i64* %j, align 8
  br label %for.cond.1

for.end.16:                                       ; preds = %for.cond.1
  br label %for.inc.17

for.inc.17:                                       ; preds = %for.end.16
  %18 = load i64* %i, align 8
  %inc18 = add nsw i64 %18, 1
  store i64 %inc18, i64* %i, align 8
  br label %for.cond

for.end.19:                                       ; preds = %for.cond
  store i64 0, i64* %i, align 8
  br label %for.cond.20

for.cond.20:                                      ; preds = %for.inc.33, %for.end.19
  %19 = load i64* %i, align 8
  %cmp21 = icmp slt i64 %19, 4
  br i1 %cmp21, label %for.body.22, label %for.end.35

for.body.22:                                      ; preds = %for.cond.20
  store i64 0, i64* %j, align 8
  br label %for.cond.23

for.cond.23:                                      ; preds = %for.inc.30, %for.body.22
  %20 = load i64* %j, align 8
  %cmp24 = icmp slt i64 %20, 4
  br i1 %cmp24, label %for.body.25, label %for.end.32

for.body.25:                                      ; preds = %for.cond.23
  %21 = load i64* %j, align 8
  %22 = load i64* %i, align 8
  %arrayidx26 = getelementptr inbounds [4 x [4 x double]]* %T, i32 0, i64 %22
  %arrayidx27 = getelementptr inbounds [4 x double]* %arrayidx26, i32 0, i64 %21
  %23 = load double* %arrayidx27, align 8
  %24 = load i64* %j, align 8
  %25 = load i64* %i, align 8
  %26 = load [4 x double]** %C.addr, align 8
  %arrayidx28 = getelementptr inbounds [4 x double]* %26, i64 %25
  %arrayidx29 = getelementptr inbounds [4 x double]* %arrayidx28, i32 0, i64 %24
  store double %23, double* %arrayidx29, align 8
  br label %for.inc.30

for.inc.30:                                       ; preds = %for.body.25
  %27 = load i64* %j, align 8
  %inc31 = add nsw i64 %27, 1
  store i64 %inc31, i64* %j, align 8
  br label %for.cond.23

for.end.32:                                       ; preds = %for.cond.23
  br label %for.inc.33

for.inc.33:                                       ; preds = %for.end.32
  %28 = load i64* %i, align 8
  %inc34 = add nsw i64 %28, 1
  store i64 %inc34, i64* %i, align 8
  br label %for.cond.20

for.end.35:                                       ; preds = %for.cond.20
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @MatrixInverse([4 x double]* %Minv, [4 x double]* %Mat) {
entry:
  %Minv.addr = alloca [4 x double]*, align 8
  %Mat.addr = alloca [4 x double]*, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %k = alloca i64, align 8
  %gjmat = alloca [4 x [8 x double]], align 16
  %tbuf = alloca [8 x double], align 16
  %pval = alloca double, align 8
  %aval = alloca double, align 8
  %prow = alloca i64, align 8
  %c = alloca double, align 8
  %tmp = alloca [4 x [4 x double]], align 16
  store [4 x double]* %Minv, [4 x double]** %Minv.addr, align 8
  store [4 x double]* %Mat, [4 x double]** %Mat.addr, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc.7, %entry
  %0 = load i64* %i, align 8
  %cmp = icmp slt i64 %0, 4
  br i1 %cmp, label %for.body, label %for.end.9

for.body:                                         ; preds = %for.cond
  store i64 0, i64* %j, align 8
  br label %for.cond.1

for.cond.1:                                       ; preds = %for.inc, %for.body
  %1 = load i64* %j, align 8
  %cmp2 = icmp slt i64 %1, 4
  br i1 %cmp2, label %for.body.3, label %for.end

for.body.3:                                       ; preds = %for.cond.1
  %2 = load i64* %j, align 8
  %3 = load i64* %i, align 8
  %4 = load [4 x double]** %Mat.addr, align 8
  %arrayidx = getelementptr inbounds [4 x double]* %4, i64 %3
  %arrayidx4 = getelementptr inbounds [4 x double]* %arrayidx, i32 0, i64 %2
  %5 = load double* %arrayidx4, align 8
  %6 = load i64* %j, align 8
  %7 = load i64* %i, align 8
  %arrayidx5 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %7
  %arrayidx6 = getelementptr inbounds [8 x double]* %arrayidx5, i32 0, i64 %6
  store double %5, double* %arrayidx6, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body.3
  %8 = load i64* %j, align 8
  %inc = add nsw i64 %8, 1
  store i64 %inc, i64* %j, align 8
  br label %for.cond.1

for.end:                                          ; preds = %for.cond.1
  br label %for.inc.7

for.inc.7:                                        ; preds = %for.end
  %9 = load i64* %i, align 8
  %inc8 = add nsw i64 %9, 1
  store i64 %inc8, i64* %i, align 8
  br label %for.cond

for.end.9:                                        ; preds = %for.cond
  store i64 0, i64* %k, align 8
  store i64 4, i64* %i, align 8
  br label %for.cond.10

for.cond.10:                                      ; preds = %for.inc.25, %for.end.9
  %10 = load i64* %i, align 8
  %cmp11 = icmp slt i64 %10, 8
  br i1 %cmp11, label %for.body.12, label %for.end.27

for.body.12:                                      ; preds = %for.cond.10
  store i64 4, i64* %j, align 8
  br label %for.cond.13

for.cond.13:                                      ; preds = %for.inc.21, %for.body.12
  %11 = load i64* %j, align 8
  %cmp14 = icmp slt i64 %11, 8
  br i1 %cmp14, label %for.body.15, label %for.end.23

for.body.15:                                      ; preds = %for.cond.13
  %12 = load i64* %i, align 8
  %13 = load i64* %j, align 8
  %cmp16 = icmp eq i64 %12, %13
  br i1 %cmp16, label %if.then, label %if.else

if.then:                                          ; preds = %for.body.15
  %14 = load i64* %j, align 8
  %15 = load i64* %k, align 8
  %arrayidx17 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %15
  %arrayidx18 = getelementptr inbounds [8 x double]* %arrayidx17, i32 0, i64 %14
  store double 1.000000e+00, double* %arrayidx18, align 8
  br label %if.end

if.else:                                          ; preds = %for.body.15
  %16 = load i64* %j, align 8
  %17 = load i64* %k, align 8
  %arrayidx19 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %17
  %arrayidx20 = getelementptr inbounds [8 x double]* %arrayidx19, i32 0, i64 %16
  store double 0.000000e+00, double* %arrayidx20, align 8
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  br label %for.inc.21

for.inc.21:                                       ; preds = %if.end
  %18 = load i64* %j, align 8
  %inc22 = add nsw i64 %18, 1
  store i64 %inc22, i64* %j, align 8
  br label %for.cond.13

for.end.23:                                       ; preds = %for.cond.13
  %19 = load i64* %k, align 8
  %inc24 = add nsw i64 %19, 1
  store i64 %inc24, i64* %k, align 8
  br label %for.inc.25

for.inc.25:                                       ; preds = %for.end.23
  %20 = load i64* %i, align 8
  %inc26 = add nsw i64 %20, 1
  store i64 %inc26, i64* %i, align 8
  br label %for.cond.10

for.end.27:                                       ; preds = %for.cond.10
  store i64 0, i64* %i, align 8
  br label %for.cond.28

for.cond.28:                                      ; preds = %for.inc.117, %for.end.27
  %21 = load i64* %i, align 8
  %cmp29 = icmp slt i64 %21, 3
  br i1 %cmp29, label %for.body.30, label %for.end.119

for.body.30:                                      ; preds = %for.cond.28
  %22 = load i64* %i, align 8
  %23 = load i64* %i, align 8
  %arrayidx31 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %23
  %arrayidx32 = getelementptr inbounds [8 x double]* %arrayidx31, i32 0, i64 %22
  %24 = load double* %arrayidx32, align 8
  %cmp33 = fcmp ogt double %24, 0.000000e+00
  br i1 %cmp33, label %cond.true, label %cond.false

cond.true:                                        ; preds = %for.body.30
  %25 = load i64* %i, align 8
  %26 = load i64* %i, align 8
  %arrayidx34 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %26
  %arrayidx35 = getelementptr inbounds [8 x double]* %arrayidx34, i32 0, i64 %25
  %27 = load double* %arrayidx35, align 8
  br label %cond.end

cond.false:                                       ; preds = %for.body.30
  %28 = load i64* %i, align 8
  %29 = load i64* %i, align 8
  %arrayidx36 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %29
  %arrayidx37 = getelementptr inbounds [8 x double]* %arrayidx36, i32 0, i64 %28
  %30 = load double* %arrayidx37, align 8
  %sub = fsub double -0.000000e+00, %30
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi double [ %27, %cond.true ], [ %sub, %cond.false ]
  store double %cond, double* %pval, align 8
  %31 = load i64* %i, align 8
  store i64 %31, i64* %prow, align 8
  %32 = load i64* %i, align 8
  %add = add nsw i64 %32, 1
  store i64 %add, i64* %j, align 8
  br label %for.cond.38

for.cond.38:                                      ; preds = %for.inc.56, %cond.end
  %33 = load i64* %j, align 8
  %cmp39 = icmp slt i64 %33, 4
  br i1 %cmp39, label %for.body.40, label %for.end.58

for.body.40:                                      ; preds = %for.cond.38
  %34 = load i64* %i, align 8
  %35 = load i64* %j, align 8
  %arrayidx41 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %35
  %arrayidx42 = getelementptr inbounds [8 x double]* %arrayidx41, i32 0, i64 %34
  %36 = load double* %arrayidx42, align 8
  %cmp43 = fcmp ogt double %36, 0.000000e+00
  br i1 %cmp43, label %cond.true.44, label %cond.false.47

cond.true.44:                                     ; preds = %for.body.40
  %37 = load i64* %i, align 8
  %38 = load i64* %j, align 8
  %arrayidx45 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %38
  %arrayidx46 = getelementptr inbounds [8 x double]* %arrayidx45, i32 0, i64 %37
  %39 = load double* %arrayidx46, align 8
  br label %cond.end.51

cond.false.47:                                    ; preds = %for.body.40
  %40 = load i64* %i, align 8
  %41 = load i64* %j, align 8
  %arrayidx48 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %41
  %arrayidx49 = getelementptr inbounds [8 x double]* %arrayidx48, i32 0, i64 %40
  %42 = load double* %arrayidx49, align 8
  %sub50 = fsub double -0.000000e+00, %42
  br label %cond.end.51

cond.end.51:                                      ; preds = %cond.false.47, %cond.true.44
  %cond52 = phi double [ %39, %cond.true.44 ], [ %sub50, %cond.false.47 ]
  store double %cond52, double* %aval, align 8
  %43 = load double* %aval, align 8
  %44 = load double* %pval, align 8
  %cmp53 = fcmp ogt double %43, %44
  br i1 %cmp53, label %if.then.54, label %if.end.55

if.then.54:                                       ; preds = %cond.end.51
  %45 = load double* %aval, align 8
  store double %45, double* %pval, align 8
  %46 = load i64* %j, align 8
  store i64 %46, i64* %prow, align 8
  br label %if.end.55

if.end.55:                                        ; preds = %if.then.54, %cond.end.51
  br label %for.inc.56

for.inc.56:                                       ; preds = %if.end.55
  %47 = load i64* %j, align 8
  %inc57 = add nsw i64 %47, 1
  store i64 %inc57, i64* %j, align 8
  br label %for.cond.38

for.end.58:                                       ; preds = %for.cond.38
  %48 = load i64* %i, align 8
  %49 = load i64* %prow, align 8
  %cmp59 = icmp ne i64 %48, %49
  br i1 %cmp59, label %if.then.60, label %if.end.89

if.then.60:                                       ; preds = %for.end.58
  store i64 0, i64* %k, align 8
  br label %for.cond.61

for.cond.61:                                      ; preds = %for.inc.67, %if.then.60
  %50 = load i64* %k, align 8
  %cmp62 = icmp slt i64 %50, 8
  br i1 %cmp62, label %for.body.63, label %for.end.69

for.body.63:                                      ; preds = %for.cond.61
  %51 = load i64* %k, align 8
  %52 = load i64* %i, align 8
  %arrayidx64 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %52
  %arrayidx65 = getelementptr inbounds [8 x double]* %arrayidx64, i32 0, i64 %51
  %53 = load double* %arrayidx65, align 8
  %54 = load i64* %k, align 8
  %arrayidx66 = getelementptr inbounds [8 x double]* %tbuf, i32 0, i64 %54
  store double %53, double* %arrayidx66, align 8
  br label %for.inc.67

for.inc.67:                                       ; preds = %for.body.63
  %55 = load i64* %k, align 8
  %inc68 = add nsw i64 %55, 1
  store i64 %inc68, i64* %k, align 8
  br label %for.cond.61

for.end.69:                                       ; preds = %for.cond.61
  store i64 0, i64* %k, align 8
  br label %for.cond.70

for.cond.70:                                      ; preds = %for.inc.77, %for.end.69
  %56 = load i64* %k, align 8
  %cmp71 = icmp slt i64 %56, 8
  br i1 %cmp71, label %for.body.72, label %for.end.79

for.body.72:                                      ; preds = %for.cond.70
  %57 = load i64* %k, align 8
  %58 = load i64* %prow, align 8
  %arrayidx73 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %58
  %arrayidx74 = getelementptr inbounds [8 x double]* %arrayidx73, i32 0, i64 %57
  %59 = load double* %arrayidx74, align 8
  %60 = load i64* %k, align 8
  %61 = load i64* %i, align 8
  %arrayidx75 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %61
  %arrayidx76 = getelementptr inbounds [8 x double]* %arrayidx75, i32 0, i64 %60
  store double %59, double* %arrayidx76, align 8
  br label %for.inc.77

for.inc.77:                                       ; preds = %for.body.72
  %62 = load i64* %k, align 8
  %inc78 = add nsw i64 %62, 1
  store i64 %inc78, i64* %k, align 8
  br label %for.cond.70

for.end.79:                                       ; preds = %for.cond.70
  store i64 0, i64* %k, align 8
  br label %for.cond.80

for.cond.80:                                      ; preds = %for.inc.86, %for.end.79
  %63 = load i64* %k, align 8
  %cmp81 = icmp slt i64 %63, 8
  br i1 %cmp81, label %for.body.82, label %for.end.88

for.body.82:                                      ; preds = %for.cond.80
  %64 = load i64* %k, align 8
  %arrayidx83 = getelementptr inbounds [8 x double]* %tbuf, i32 0, i64 %64
  %65 = load double* %arrayidx83, align 8
  %66 = load i64* %k, align 8
  %67 = load i64* %prow, align 8
  %arrayidx84 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %67
  %arrayidx85 = getelementptr inbounds [8 x double]* %arrayidx84, i32 0, i64 %66
  store double %65, double* %arrayidx85, align 8
  br label %for.inc.86

for.inc.86:                                       ; preds = %for.body.82
  %68 = load i64* %k, align 8
  %inc87 = add nsw i64 %68, 1
  store i64 %inc87, i64* %k, align 8
  br label %for.cond.80

for.end.88:                                       ; preds = %for.cond.80
  br label %if.end.89

if.end.89:                                        ; preds = %for.end.88, %for.end.58
  %69 = load i64* %i, align 8
  %add90 = add nsw i64 %69, 1
  store i64 %add90, i64* %j, align 8
  br label %for.cond.91

for.cond.91:                                      ; preds = %for.inc.114, %if.end.89
  %70 = load i64* %j, align 8
  %cmp92 = icmp slt i64 %70, 4
  br i1 %cmp92, label %for.body.93, label %for.end.116

for.body.93:                                      ; preds = %for.cond.91
  %71 = load i64* %i, align 8
  %72 = load i64* %j, align 8
  %arrayidx94 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %72
  %arrayidx95 = getelementptr inbounds [8 x double]* %arrayidx94, i32 0, i64 %71
  %73 = load double* %arrayidx95, align 8
  %74 = load i64* %i, align 8
  %75 = load i64* %i, align 8
  %arrayidx96 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %75
  %arrayidx97 = getelementptr inbounds [8 x double]* %arrayidx96, i32 0, i64 %74
  %76 = load double* %arrayidx97, align 8
  %div = fdiv double %73, %76
  store double %div, double* %c, align 8
  %77 = load i64* %i, align 8
  %78 = load i64* %j, align 8
  %arrayidx98 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %78
  %arrayidx99 = getelementptr inbounds [8 x double]* %arrayidx98, i32 0, i64 %77
  store double 0.000000e+00, double* %arrayidx99, align 8
  %79 = load i64* %i, align 8
  %add100 = add nsw i64 %79, 1
  store i64 %add100, i64* %k, align 8
  br label %for.cond.101

for.cond.101:                                     ; preds = %for.inc.111, %for.body.93
  %80 = load i64* %k, align 8
  %cmp102 = icmp slt i64 %80, 8
  br i1 %cmp102, label %for.body.103, label %for.end.113

for.body.103:                                     ; preds = %for.cond.101
  %81 = load i64* %k, align 8
  %82 = load i64* %j, align 8
  %arrayidx104 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %82
  %arrayidx105 = getelementptr inbounds [8 x double]* %arrayidx104, i32 0, i64 %81
  %83 = load double* %arrayidx105, align 8
  %84 = load double* %c, align 8
  %85 = load i64* %k, align 8
  %86 = load i64* %i, align 8
  %arrayidx106 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %86
  %arrayidx107 = getelementptr inbounds [8 x double]* %arrayidx106, i32 0, i64 %85
  %87 = load double* %arrayidx107, align 8
  %mul = fmul double %84, %87
  %sub108 = fsub double %83, %mul
  %88 = load i64* %k, align 8
  %89 = load i64* %j, align 8
  %arrayidx109 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %89
  %arrayidx110 = getelementptr inbounds [8 x double]* %arrayidx109, i32 0, i64 %88
  store double %sub108, double* %arrayidx110, align 8
  br label %for.inc.111

for.inc.111:                                      ; preds = %for.body.103
  %90 = load i64* %k, align 8
  %inc112 = add nsw i64 %90, 1
  store i64 %inc112, i64* %k, align 8
  br label %for.cond.101

for.end.113:                                      ; preds = %for.cond.101
  br label %for.inc.114

for.inc.114:                                      ; preds = %for.end.113
  %91 = load i64* %j, align 8
  %inc115 = add nsw i64 %91, 1
  store i64 %inc115, i64* %j, align 8
  br label %for.cond.91

for.end.116:                                      ; preds = %for.cond.91
  br label %for.inc.117

for.inc.117:                                      ; preds = %for.end.116
  %92 = load i64* %i, align 8
  %inc118 = add nsw i64 %92, 1
  store i64 %inc118, i64* %i, align 8
  br label %for.cond.28

for.end.119:                                      ; preds = %for.cond.28
  store i64 0, i64* %i, align 8
  br label %for.cond.120

for.cond.120:                                     ; preds = %for.inc.152, %for.end.119
  %93 = load i64* %i, align 8
  %cmp121 = icmp slt i64 %93, 3
  br i1 %cmp121, label %for.body.122, label %for.end.154

for.body.122:                                     ; preds = %for.cond.120
  %94 = load i64* %i, align 8
  %add123 = add nsw i64 %94, 1
  store i64 %add123, i64* %j, align 8
  br label %for.cond.124

for.cond.124:                                     ; preds = %for.inc.149, %for.body.122
  %95 = load i64* %j, align 8
  %cmp125 = icmp slt i64 %95, 4
  br i1 %cmp125, label %for.body.126, label %for.end.151

for.body.126:                                     ; preds = %for.cond.124
  %96 = load i64* %j, align 8
  %97 = load i64* %i, align 8
  %arrayidx127 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %97
  %arrayidx128 = getelementptr inbounds [8 x double]* %arrayidx127, i32 0, i64 %96
  %98 = load double* %arrayidx128, align 8
  %99 = load i64* %j, align 8
  %100 = load i64* %j, align 8
  %arrayidx129 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %100
  %arrayidx130 = getelementptr inbounds [8 x double]* %arrayidx129, i32 0, i64 %99
  %101 = load double* %arrayidx130, align 8
  %div131 = fdiv double %98, %101
  store double %div131, double* %c, align 8
  %102 = load i64* %j, align 8
  %103 = load i64* %i, align 8
  %arrayidx132 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %103
  %arrayidx133 = getelementptr inbounds [8 x double]* %arrayidx132, i32 0, i64 %102
  store double 0.000000e+00, double* %arrayidx133, align 8
  %104 = load i64* %j, align 8
  %add134 = add nsw i64 %104, 1
  store i64 %add134, i64* %k, align 8
  br label %for.cond.135

for.cond.135:                                     ; preds = %for.inc.146, %for.body.126
  %105 = load i64* %k, align 8
  %cmp136 = icmp slt i64 %105, 8
  br i1 %cmp136, label %for.body.137, label %for.end.148

for.body.137:                                     ; preds = %for.cond.135
  %106 = load i64* %k, align 8
  %107 = load i64* %i, align 8
  %arrayidx138 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %107
  %arrayidx139 = getelementptr inbounds [8 x double]* %arrayidx138, i32 0, i64 %106
  %108 = load double* %arrayidx139, align 8
  %109 = load double* %c, align 8
  %110 = load i64* %k, align 8
  %111 = load i64* %j, align 8
  %arrayidx140 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %111
  %arrayidx141 = getelementptr inbounds [8 x double]* %arrayidx140, i32 0, i64 %110
  %112 = load double* %arrayidx141, align 8
  %mul142 = fmul double %109, %112
  %sub143 = fsub double %108, %mul142
  %113 = load i64* %k, align 8
  %114 = load i64* %i, align 8
  %arrayidx144 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %114
  %arrayidx145 = getelementptr inbounds [8 x double]* %arrayidx144, i32 0, i64 %113
  store double %sub143, double* %arrayidx145, align 8
  br label %for.inc.146

for.inc.146:                                      ; preds = %for.body.137
  %115 = load i64* %k, align 8
  %inc147 = add nsw i64 %115, 1
  store i64 %inc147, i64* %k, align 8
  br label %for.cond.135

for.end.148:                                      ; preds = %for.cond.135
  br label %for.inc.149

for.inc.149:                                      ; preds = %for.end.148
  %116 = load i64* %j, align 8
  %inc150 = add nsw i64 %116, 1
  store i64 %inc150, i64* %j, align 8
  br label %for.cond.124

for.end.151:                                      ; preds = %for.cond.124
  br label %for.inc.152

for.inc.152:                                      ; preds = %for.end.151
  %117 = load i64* %i, align 8
  %inc153 = add nsw i64 %117, 1
  store i64 %inc153, i64* %i, align 8
  br label %for.cond.120

for.end.154:                                      ; preds = %for.cond.120
  store i64 0, i64* %i, align 8
  br label %for.cond.155

for.cond.155:                                     ; preds = %for.inc.169, %for.end.154
  %118 = load i64* %i, align 8
  %cmp156 = icmp slt i64 %118, 4
  br i1 %cmp156, label %for.body.157, label %for.end.171

for.body.157:                                     ; preds = %for.cond.155
  store i64 4, i64* %k, align 8
  br label %for.cond.158

for.cond.158:                                     ; preds = %for.inc.166, %for.body.157
  %119 = load i64* %k, align 8
  %cmp159 = icmp slt i64 %119, 8
  br i1 %cmp159, label %for.body.160, label %for.end.168

for.body.160:                                     ; preds = %for.cond.158
  %120 = load i64* %i, align 8
  %121 = load i64* %i, align 8
  %arrayidx161 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %121
  %arrayidx162 = getelementptr inbounds [8 x double]* %arrayidx161, i32 0, i64 %120
  %122 = load double* %arrayidx162, align 8
  %123 = load i64* %k, align 8
  %124 = load i64* %i, align 8
  %arrayidx163 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %124
  %arrayidx164 = getelementptr inbounds [8 x double]* %arrayidx163, i32 0, i64 %123
  %125 = load double* %arrayidx164, align 8
  %div165 = fdiv double %125, %122
  store double %div165, double* %arrayidx164, align 8
  br label %for.inc.166

for.inc.166:                                      ; preds = %for.body.160
  %126 = load i64* %k, align 8
  %inc167 = add nsw i64 %126, 1
  store i64 %inc167, i64* %k, align 8
  br label %for.cond.158

for.end.168:                                      ; preds = %for.cond.158
  br label %for.inc.169

for.inc.169:                                      ; preds = %for.end.168
  %127 = load i64* %i, align 8
  %inc170 = add nsw i64 %127, 1
  store i64 %inc170, i64* %i, align 8
  br label %for.cond.155

for.end.171:                                      ; preds = %for.cond.155
  store i64 0, i64* %i, align 8
  br label %for.cond.172

for.cond.172:                                     ; preds = %for.inc.186, %for.end.171
  %128 = load i64* %i, align 8
  %cmp173 = icmp slt i64 %128, 4
  br i1 %cmp173, label %for.body.174, label %for.end.188

for.body.174:                                     ; preds = %for.cond.172
  store i64 4, i64* %j, align 8
  br label %for.cond.175

for.cond.175:                                     ; preds = %for.inc.183, %for.body.174
  %129 = load i64* %j, align 8
  %cmp176 = icmp slt i64 %129, 8
  br i1 %cmp176, label %for.body.177, label %for.end.185

for.body.177:                                     ; preds = %for.cond.175
  %130 = load i64* %j, align 8
  %131 = load i64* %i, align 8
  %arrayidx178 = getelementptr inbounds [4 x [8 x double]]* %gjmat, i32 0, i64 %131
  %arrayidx179 = getelementptr inbounds [8 x double]* %arrayidx178, i32 0, i64 %130
  %132 = load double* %arrayidx179, align 8
  %133 = load i64* %j, align 8
  %sub180 = sub nsw i64 %133, 4
  %134 = load i64* %i, align 8
  %135 = load [4 x double]** %Minv.addr, align 8
  %arrayidx181 = getelementptr inbounds [4 x double]* %135, i64 %134
  %arrayidx182 = getelementptr inbounds [4 x double]* %arrayidx181, i32 0, i64 %sub180
  store double %132, double* %arrayidx182, align 8
  br label %for.inc.183

for.inc.183:                                      ; preds = %for.body.177
  %136 = load i64* %j, align 8
  %inc184 = add nsw i64 %136, 1
  store i64 %inc184, i64* %j, align 8
  br label %for.cond.175

for.end.185:                                      ; preds = %for.cond.175
  br label %for.inc.186

for.inc.186:                                      ; preds = %for.end.185
  %137 = load i64* %i, align 8
  %inc187 = add nsw i64 %137, 1
  store i64 %inc187, i64* %i, align 8
  br label %for.cond.172

for.end.188:                                      ; preds = %for.cond.172
  %arraydecay = getelementptr inbounds [4 x [4 x double]]* %tmp, i32 0, i32 0
  %138 = load [4 x double]** %Mat.addr, align 8
  %139 = load [4 x double]** %Minv.addr, align 8
  call void @MatrixMult([4 x double]* %arraydecay, [4 x double]* %138, [4 x double]* %139)
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @Translate([4 x double]* %M, double %dx, double %dy, double %dz) {
entry:
  %M.addr = alloca [4 x double]*, align 8
  %dx.addr = alloca double, align 8
  %dy.addr = alloca double, align 8
  %dz.addr = alloca double, align 8
  store [4 x double]* %M, [4 x double]** %M.addr, align 8
  store double %dz, double* %dz.addr, align 8
  %0 = load [4 x double]** %M.addr, align 8
  call void @MatrixIdentity([4 x double]* %0)
  %1 = load double* %dz.addr, align 8
  %2 = load [4 x double]** %M.addr, align 8
  %arrayidx4 = getelementptr inbounds [4 x double]* %2, i64 3
  %arrayidx5 = getelementptr inbounds [4 x double]* %arrayidx4, i32 0, i64 2
  store double %1, double* %arrayidx5, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @Scale([4 x double]* %M, double %sx, double %sy, double %sz) {
entry:
  %M.addr = alloca [4 x double]*, align 8
  %sx.addr = alloca double, align 8
  %sy.addr = alloca double, align 8
  %sz.addr = alloca double, align 8
  store [4 x double]* %M, [4 x double]** %M.addr, align 8
  store double %sx, double* %sx.addr, align 8
  %0 = load [4 x double]** %M.addr, align 8
  call void @MatrixIdentity([4 x double]* %0)
  %1 = load double* %sx.addr, align 8
  %2 = load [4 x double]** %M.addr, align 8
  %arrayidx = getelementptr inbounds [4 x double]* %2, i64 0
  %arrayidx1 = getelementptr inbounds [4 x double]* %arrayidx, i32 0, i64 0
  store double %1, double* %arrayidx1, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @Rotate(i64 %axis, [4 x double]* %M, double %angle) {
entry:
  %axis.addr = alloca i64, align 8
  %M.addr = alloca [4 x double]*, align 8
  %angle.addr = alloca double, align 8
  %cosangle = alloca double, align 8
  %sinangle = alloca double, align 8
  store i64 %axis, i64* %axis.addr, align 8
  store [4 x double]* %M, [4 x double]** %M.addr, align 8
  %0 = load [4 x double]** %M.addr, align 8
  call void @MatrixIdentity([4 x double]* %0)
  %call = call double @cos(double undef)
  store double %call, double* %cosangle, align 8
  %call1 = call double @sin(double undef)
  store double %call1, double* %sinangle, align 8
  %1 = load i64* %axis.addr, align 8
  switch i64 %1, label %sw.default [
    i64 1, label %sw.bb
    i64 2, label %sw.bb.9
    i64 3, label %sw.bb.19
  ]

sw.bb:                                            ; preds = %entry
  %2 = load double* %cosangle, align 8
  %3 = load [4 x double]** %M.addr, align 8
  %arrayidx = getelementptr inbounds [4 x double]* %3, i64 1
  %arrayidx2 = getelementptr inbounds [4 x double]* %arrayidx, i32 0, i64 1
  store double %2, double* %arrayidx2, align 8
  %4 = load double* %sinangle, align 8
  %5 = load [4 x double]** %M.addr, align 8
  %arrayidx3 = getelementptr inbounds [4 x double]* %5, i64 1
  %arrayidx4 = getelementptr inbounds [4 x double]* %arrayidx3, i32 0, i64 2
  store double %4, double* %arrayidx4, align 8
  %6 = load double* %sinangle, align 8
  %sub = fsub double -0.000000e+00, %6
  %7 = load [4 x double]** %M.addr, align 8
  %arrayidx5 = getelementptr inbounds [4 x double]* %7, i64 2
  %arrayidx6 = getelementptr inbounds [4 x double]* %arrayidx5, i32 0, i64 1
  store double %sub, double* %arrayidx6, align 8
  %8 = load double* %cosangle, align 8
  %9 = load [4 x double]** %M.addr, align 8
  %arrayidx7 = getelementptr inbounds [4 x double]* %9, i64 2
  %arrayidx8 = getelementptr inbounds [4 x double]* %arrayidx7, i32 0, i64 2
  store double %8, double* %arrayidx8, align 8
  br label %sw.epilog

sw.bb.9:                                          ; preds = %entry
  %10 = load double* %cosangle, align 8
  %11 = load [4 x double]** %M.addr, align 8
  %arrayidx10 = getelementptr inbounds [4 x double]* %11, i64 0
  %arrayidx11 = getelementptr inbounds [4 x double]* %arrayidx10, i32 0, i64 0
  store double %10, double* %arrayidx11, align 8
  %12 = load double* %sinangle, align 8
  %sub12 = fsub double -0.000000e+00, %12
  %13 = load [4 x double]** %M.addr, align 8
  %arrayidx13 = getelementptr inbounds [4 x double]* %13, i64 0
  %arrayidx14 = getelementptr inbounds [4 x double]* %arrayidx13, i32 0, i64 2
  store double %sub12, double* %arrayidx14, align 8
  %14 = load double* %sinangle, align 8
  %15 = load [4 x double]** %M.addr, align 8
  %arrayidx15 = getelementptr inbounds [4 x double]* %15, i64 2
  %arrayidx16 = getelementptr inbounds [4 x double]* %arrayidx15, i32 0, i64 0
  store double %14, double* %arrayidx16, align 8
  %16 = load double* %cosangle, align 8
  %17 = load [4 x double]** %M.addr, align 8
  %arrayidx17 = getelementptr inbounds [4 x double]* %17, i64 2
  %arrayidx18 = getelementptr inbounds [4 x double]* %arrayidx17, i32 0, i64 2
  store double %16, double* %arrayidx18, align 8
  br label %sw.epilog

sw.bb.19:                                         ; preds = %entry
  %18 = load double* %cosangle, align 8
  %19 = load [4 x double]** %M.addr, align 8
  %arrayidx20 = getelementptr inbounds [4 x double]* %19, i64 0
  %arrayidx21 = getelementptr inbounds [4 x double]* %arrayidx20, i32 0, i64 0
  store double %18, double* %arrayidx21, align 8
  %20 = load double* %sinangle, align 8
  %21 = load [4 x double]** %M.addr, align 8
  %arrayidx22 = getelementptr inbounds [4 x double]* %21, i64 0
  %arrayidx23 = getelementptr inbounds [4 x double]* %arrayidx22, i32 0, i64 1
  store double %20, double* %arrayidx23, align 8
  %22 = load double* %sinangle, align 8
  %sub24 = fsub double -0.000000e+00, %22
  %23 = load [4 x double]** %M.addr, align 8
  %arrayidx25 = getelementptr inbounds [4 x double]* %23, i64 1
  %arrayidx26 = getelementptr inbounds [4 x double]* %arrayidx25, i32 0, i64 0
  store double %sub24, double* %arrayidx26, align 8
  %24 = load double* %cosangle, align 8
  %25 = load [4 x double]** %M.addr, align 8
  %arrayidx27 = getelementptr inbounds [4 x double]* %25, i64 1
  %arrayidx28 = getelementptr inbounds [4 x double]* %arrayidx27, i32 0, i64 1
  store double %24, double* %arrayidx28, align 8
  br label %sw.epilog

sw.default:                                       ; preds = %entry
  unreachable

sw.epilog:                                        ; preds = %sw.bb.19, %sw.bb.9, %sw.bb
  ret void
}

; Function Attrs: nounwind
declare double @cos(double)

; Function Attrs: nounwind
declare double @sin(double)

; Function Attrs: nounwind uwtable
define internal i8* @LocalMalloc(i64 %n, i8* %msg) {
entry:
  %n.addr = alloca i64, align 8
  %msg.addr = alloca i8*, align 8
  %p = alloca i8*, align 8
  br i1 undef, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  unreachable

if.end:                                           ; preds = %entry
  ret i8* undef
}

; Function Attrs: nounwind uwtable
define internal void @LocalFree(i8* %p) {
entry:
  %p.addr = alloca i8*, align 8
  ret void
}

declare i32 @free(...)

; Function Attrs: nounwind uwtable
define internal void @GlobalHeapWalk() {
entry:
  %curr = alloca %struct.node*, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  br i1 undef, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  br i1 undef, label %if.then, label %if.end

if.then:                                          ; preds = %while.body
  unreachable

if.end:                                           ; preds = %while.body
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal i64 @GlobalHeapInit(i64 %size) {
entry:
  %retval = alloca i64, align 8
  %size.addr = alloca i64, align 8
  %i = alloca i64, align 8
  %ptr = alloca i8*, align 8
  store i64 %size, i64* %size.addr, align 8
  %0 = load i64* %size.addr, align 8
  %add = add i64 %0, 7
  %shr = lshr i64 %add, 3
  %shl = shl i64 %shr, 3
  store i64 %shl, i64* %size.addr, align 8
  %1 = load i64* %size.addr, align 8
  %call = call i8* @malloc(i64 %1)
  %2 = bitcast i8* %call to %struct.node*
  %3 = load %struct.gmem** @gm, align 8
  %freelist = getelementptr inbounds %struct.gmem* %3, i32 0, i32 5
  store %struct.node* %2, %struct.node** %freelist, align 8
  %4 = load %struct.gmem** @gm, align 8
  %freelist1 = getelementptr inbounds %struct.gmem* %4, i32 0, i32 5
  %5 = load %struct.node** %freelist1, align 8
  %tobool = icmp ne %struct.node* %5, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  store i64 0, i64* %retval
  br label %return

if.end:                                           ; preds = %entry
  store i64 32, i64* @nodesize, align 8
  %6 = load i64* %size.addr, align 8
  %7 = load i64* @nodesize, align 8
  %sub = sub i64 %6, %7
  %8 = load %struct.gmem** @gm, align 8
  %freelist4 = getelementptr inbounds %struct.gmem* %8, i32 0, i32 5
  %9 = load %struct.node** %freelist4, align 8
  %size5 = getelementptr inbounds %struct.node* %9, i32 0, i32 1
  store i64 %sub, i64* %size5, align 8
  %10 = load %struct.gmem** @gm, align 8
  %freelist6 = getelementptr inbounds %struct.gmem* %10, i32 0, i32 5
  %11 = load %struct.node** %freelist6, align 8
  %next = getelementptr inbounds %struct.node* %11, i32 0, i32 0
  store %struct.node* null, %struct.node** %next, align 8
  %12 = load %struct.gmem** @gm, align 8
  %freelist7 = getelementptr inbounds %struct.gmem* %12, i32 0, i32 5
  %13 = load %struct.node** %freelist7, align 8
  %free = getelementptr inbounds %struct.node* %13, i32 0, i32 2
  store i64 1, i64* %free, align 8
  %14 = load %struct.gmem** @gm, align 8
  %freelist8 = getelementptr inbounds %struct.gmem* %14, i32 0, i32 5
  %15 = load %struct.node** %freelist8, align 8
  %cksm = getelementptr inbounds %struct.node* %15, i32 0, i32 3
  store i64 1437226410, i64* %cksm, align 8
  store i64 1, i64* %retval
  br label %return

return:                                           ; preds = %if.end, %if.then
  %16 = load i64* %retval
  ret i64 %16
}

; Function Attrs: nounwind uwtable
define internal i8* @GlobalMalloc(i64 %size, i8* %msg) {
entry:
  %retval = alloca i8*, align 8
  %size.addr = alloca i64, align 8
  %msg.addr = alloca i8*, align 8
  %prev = alloca %struct.node*, align 8
  %curr = alloca %struct.node*, align 8
  %next = alloca %struct.node*, align 8
  store i64 %size, i64* %size.addr, align 8
  %0 = load i64* %size.addr, align 8
  %tobool = icmp ne i64 %0, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  store i8* null, i8** %retval
  br label %return

if.end:                                           ; preds = %entry
  store %struct.node* null, %struct.node** %prev, align 8
  %1 = load %struct.gmem** @gm, align 8
  %freelist = getelementptr inbounds %struct.gmem* %1, i32 0, i32 5
  %2 = load %struct.node** %freelist, align 8
  store %struct.node* %2, %struct.node** %curr, align 8
  %3 = load i64* %size.addr, align 8
  %add = add i64 %3, 7
  %shr = lshr i64 %add, 3
  %shl = shl i64 %shr, 3
  store i64 %shl, i64* %size.addr, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end.10, %if.end
  %4 = load %struct.node** %curr, align 8
  %tobool1 = icmp ne %struct.node* %4, null
  br i1 %tobool1, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %while.cond
  %5 = load %struct.node** %curr, align 8
  %size2 = getelementptr inbounds %struct.node* %5, i32 0, i32 1
  %6 = load i64* %size2, align 8
  %7 = load i64* %size.addr, align 8
  %cmp = icmp ult i64 %6, %7
  br label %land.end

land.end:                                         ; preds = %land.rhs, %while.cond
  %8 = phi i1 [ false, %while.cond ], [ %cmp, %land.rhs ]
  br i1 %8, label %while.body, label %while.end

while.body:                                       ; preds = %land.end
  %9 = load %struct.node** %curr, align 8
  %cksm = getelementptr inbounds %struct.node* %9, i32 0, i32 3
  %10 = load i64* %cksm, align 8
  %cmp3 = icmp ne i64 %10, 1437226410
  br i1 %cmp3, label %if.then.4, label %if.end.6

if.then.4:                                        ; preds = %while.body
  br label %UnifiedUnreachableBlock

if.end.6:                                         ; preds = %while.body
  %11 = load %struct.node** %curr, align 8
  %free = getelementptr inbounds %struct.node* %11, i32 0, i32 2
  %12 = load i64* %free, align 8
  %cmp7 = icmp ne i64 %12, 1
  br i1 %cmp7, label %if.then.8, label %if.end.10

if.then.8:                                        ; preds = %if.end.6
  br label %UnifiedUnreachableBlock

if.end.10:                                        ; preds = %if.end.6
  %13 = load %struct.node** %curr, align 8
  store %struct.node* %13, %struct.node** %prev, align 8
  %14 = load %struct.node** %curr, align 8
  %next11 = getelementptr inbounds %struct.node* %14, i32 0, i32 0
  %15 = load %struct.node** %next11, align 8
  store %struct.node* %15, %struct.node** %curr, align 8
  br label %while.cond

while.end:                                        ; preds = %land.end
  %16 = load %struct.node** %curr, align 8
  %tobool12 = icmp ne %struct.node* %16, null
  br i1 %tobool12, label %if.end.15, label %if.then.13

if.then.13:                                       ; preds = %while.end
  br label %UnifiedUnreachableBlock

if.end.15:                                        ; preds = %while.end
  %17 = load %struct.node** %curr, align 8
  %size16 = getelementptr inbounds %struct.node* %17, i32 0, i32 1
  %18 = load i64* %size16, align 8
  %19 = load i64* %size.addr, align 8
  %sub = sub i64 %18, %19
  %cmp17 = icmp ugt i64 %sub, 48
  br i1 %cmp17, label %if.then.18, label %if.else

if.then.18:                                       ; preds = %if.end.15
  %20 = load %struct.node** %curr, align 8
  %21 = bitcast %struct.node* %20 to i8*
  %22 = load i64* @nodesize, align 8
  %23 = load i64* %size.addr, align 8
  %add19 = add i64 %22, %23
  %add.ptr = getelementptr inbounds i8* %21, i64 %add19
  %24 = bitcast i8* %add.ptr to %struct.node*
  store %struct.node* %24, %struct.node** %next, align 8
  %25 = load %struct.node** %next, align 8
  %cksm27 = getelementptr inbounds %struct.node* %25, i32 0, i32 3
  store i64 1437226410, i64* %cksm27, align 8
  %26 = load i64* %size.addr, align 8
  %27 = load %struct.node** %curr, align 8
  %size28 = getelementptr inbounds %struct.node* %27, i32 0, i32 1
  store i64 %26, i64* %size28, align 8
  br label %if.end.30

if.else:                                          ; preds = %if.end.15
  %28 = load %struct.node** %curr, align 8
  %next29 = getelementptr inbounds %struct.node* %28, i32 0, i32 0
  %29 = load %struct.node** %next29, align 8
  store %struct.node* %29, %struct.node** %next, align 8
  br label %if.end.30

if.end.30:                                        ; preds = %if.else, %if.then.18
  %30 = load %struct.node** %prev, align 8
  %tobool31 = icmp ne %struct.node* %30, null
  br i1 %tobool31, label %if.else.34, label %if.then.32

if.then.32:                                       ; preds = %if.end.30
  %31 = load %struct.node** %next, align 8
  %32 = load %struct.gmem** @gm, align 8
  %freelist33 = getelementptr inbounds %struct.gmem* %32, i32 0, i32 5
  store %struct.node* %31, %struct.node** %freelist33, align 8
  br label %if.end.36

if.else.34:                                       ; preds = %if.end.30
  br label %if.end.36

if.end.36:                                        ; preds = %if.else.34, %if.then.32
  %33 = load %struct.node** %curr, align 8
  %next39 = getelementptr inbounds %struct.node* %33, i32 0, i32 0
  store %struct.node* null, %struct.node** %next39, align 8
  %34 = load %struct.node** %curr, align 8
  %free40 = getelementptr inbounds %struct.node* %34, i32 0, i32 2
  store i64 0, i64* %free40, align 8
  %35 = load %struct.node** %curr, align 8
  %36 = bitcast %struct.node* %35 to i8*
  %37 = load i64* @nodesize, align 8
  %add.ptr41 = getelementptr inbounds i8* %36, i64 %37
  %38 = bitcast i8* %add.ptr41 to %struct.node*
  store %struct.node* %38, %struct.node** %curr, align 8
  %39 = load %struct.node** %curr, align 8
  %40 = bitcast %struct.node* %39 to i8*
  store i8* %40, i8** %retval
  br label %return

return:                                           ; preds = %if.end.36, %if.then
  %41 = load i8** %retval
  ret i8* %41

UnifiedUnreachableBlock:                          ; preds = %if.then.13, %if.then.8, %if.then.4
  unreachable
}

; Function Attrs: nounwind uwtable
define internal i8* @GlobalCalloc(i64 %n, i64 %size) {
entry:
  %n.addr = alloca i64, align 8
  %size.addr = alloca i64, align 8
  %nbytes = alloca i64, align 8
  %p = alloca i64*, align 8
  %q = alloca i8*, align 8
  store i64 %n, i64* %n.addr, align 8
  store i64 %size, i64* %size.addr, align 8
  %0 = load i64* %n.addr, align 8
  %1 = load i64* %size.addr, align 8
  %mul = mul i64 %0, %1
  %add = add i64 %mul, 7
  %shr = lshr i64 %add, 3
  %shl = shl i64 %shr, 3
  store i64 %shl, i64* %nbytes, align 8
  %2 = load i64* %nbytes, align 8
  %call = call i8* @GlobalMalloc(i64 %2, i8* getelementptr inbounds ([13 x i8]* @.str.11.318, i32 0, i32 0))
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  br label %while.end

while.body:                                       ; No predecessors!
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret i8* undef
}

; Function Attrs: nounwind uwtable
define internal i8* @GlobalRealloc(i8* %p, i64 %size) {
entry:
  %retval = alloca i8*, align 8
  %p.addr = alloca i8*, align 8
  %size.addr = alloca i64, align 8
  %oldsize = alloca i64, align 8
  %newsize = alloca i64, align 8
  %totsize = alloca i64, align 8
  %q = alloca i8*, align 8
  %r = alloca i64*, align 8
  %s = alloca i64*, align 8
  %pn = alloca %struct.node*, align 8
  %prev = alloca %struct.node*, align 8
  %curr = alloca %struct.node*, align 8
  %next = alloca %struct.node*, align 8
  %node = alloca %struct.node*, align 8
  store i8* %p, i8** %p.addr, align 8
  store i64 %size, i64* %size.addr, align 8
  %0 = load i64* %size.addr, align 8
  %tobool = icmp ne i64 %0, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  br label %return

if.end:                                           ; preds = %entry
  %1 = load i8** %p.addr, align 8
  %tobool1 = icmp ne i8* %1, null
  br i1 %tobool1, label %if.end.3, label %if.then.2

if.then.2:                                        ; preds = %if.end
  %2 = load i64* %size.addr, align 8
  %call = call i8* @GlobalMalloc(i64 %2, i8* getelementptr inbounds ([14 x i8]* @.str.12.319, i32 0, i32 0))
  br label %return

if.end.3:                                         ; preds = %if.end
  %3 = load i8** %p.addr, align 8
  %4 = load i64* @nodesize, align 8
  %sub = sub i64 0, %4
  %add.ptr = getelementptr inbounds i8* %3, i64 %sub
  %5 = bitcast i8* %add.ptr to %struct.node*
  store %struct.node* %5, %struct.node** %pn, align 8
  %6 = load %struct.node** %pn, align 8
  %cksm = getelementptr inbounds %struct.node* %6, i32 0, i32 3
  %7 = load i64* %cksm, align 8
  %cmp = icmp ne i64 %7, 1437226410
  br i1 %cmp, label %if.then.4, label %if.end.6

if.then.4:                                        ; preds = %if.end.3
  br label %UnifiedUnreachableBlock

if.end.6:                                         ; preds = %if.end.3
  %8 = load %struct.node** %pn, align 8
  %free = getelementptr inbounds %struct.node* %8, i32 0, i32 2
  %9 = load i64* %free, align 8
  %tobool7 = icmp ne i64 %9, 0
  br i1 %tobool7, label %if.then.8, label %if.end.10

if.then.8:                                        ; preds = %if.end.6
  br label %UnifiedUnreachableBlock

if.end.10:                                        ; preds = %if.end.6
  %10 = load i64* %size.addr, align 8
  %add = add i64 %10, 7
  %shr = lshr i64 %add, 3
  %shl = shl i64 %shr, 3
  store i64 %shl, i64* %newsize, align 8
  %11 = load %struct.node** %pn, align 8
  %size11 = getelementptr inbounds %struct.node* %11, i32 0, i32 1
  %12 = load i64* %size11, align 8
  store i64 %12, i64* %oldsize, align 8
  %13 = load i64* %newsize, align 8
  %14 = load i64* %oldsize, align 8
  %cmp12 = icmp ule i64 %13, %14
  br i1 %cmp12, label %if.then.13, label %if.end.27

if.then.13:                                       ; preds = %if.end.10
  br label %return

if.then.16:                                       ; No predecessors!
  br label %return

if.end.17:                                        ; No predecessors!
  br label %return

if.end.27:                                        ; preds = %if.end.10
  %15 = load i8** %p.addr, align 8
  %16 = load i64* %oldsize, align 8
  %add.ptr28 = getelementptr inbounds i8* %15, i64 %16
  %17 = bitcast i8* %add.ptr28 to %struct.node*
  store %struct.node* %17, %struct.node** %next, align 8
  %18 = load i64* %oldsize, align 8
  %19 = load i64* @nodesize, align 8
  %add29 = add i64 %18, %19
  %20 = load %struct.node** %next, align 8
  %size30 = getelementptr inbounds %struct.node* %20, i32 0, i32 1
  %21 = load i64* %size30, align 8
  %add31 = add i64 %add29, %21
  store i64 %add31, i64* %totsize, align 8
  %22 = load %struct.node** %next, align 8
  %23 = load %struct.node** @endmem, align 8
  %cmp33 = icmp ult %struct.node* %22, %23
  br i1 %cmp33, label %land.lhs.true, label %if.end.83

land.lhs.true:                                    ; preds = %if.end.27
  %24 = load %struct.node** %next, align 8
  %free34 = getelementptr inbounds %struct.node* %24, i32 0, i32 2
  %25 = load i64* %free34, align 8
  %tobool35 = icmp ne i64 %25, 0
  br i1 %tobool35, label %land.lhs.true.36, label %if.end.83

land.lhs.true.36:                                 ; preds = %land.lhs.true
  %26 = load i64* %totsize, align 8
  %27 = load i64* %newsize, align 8
  %cmp37 = icmp uge i64 %26, %27
  br i1 %cmp37, label %if.then.38, label %if.end.83

if.then.38:                                       ; preds = %land.lhs.true.36
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.then.38
  br label %land.end

land.lhs.true.40:                                 ; No predecessors!
  br label %land.end

land.rhs:                                         ; No predecessors!
  br label %land.end

land.end:                                         ; preds = %land.lhs.true.40, %while.cond, %land.rhs
  br label %while.end

while.body:                                       ; No predecessors!
  br label %while.cond

while.end:                                        ; preds = %land.end
  br i1 undef, label %if.then.45, label %if.end.47

if.then.45:                                       ; preds = %while.end
  br label %UnifiedUnreachableBlock

if.end.47:                                        ; preds = %while.end
  br label %return

if.then.50:                                       ; No predecessors!
  br label %if.end.57

if.then.52:                                       ; No predecessors!
  br label %if.end.57

if.else:                                          ; No predecessors!
  br label %if.end.57

if.end.57:                                        ; preds = %if.then.50, %if.else, %if.then.52
  br label %return

if.else.63:                                       ; No predecessors!
  br label %if.end.77

if.then.73:                                       ; No predecessors!
  br label %if.end.77

if.else.75:                                       ; No predecessors!
  br label %if.end.77

if.end.77:                                        ; preds = %if.else.63, %if.else.75, %if.then.73
  br label %return

if.end.83:                                        ; preds = %land.lhs.true.36, %land.lhs.true, %if.end.27
  %28 = load i64* %newsize, align 8
  %call86 = call i8* @GlobalMalloc(i64 %28, i8* getelementptr inbounds ([14 x i8]* @.str.12.319, i32 0, i32 0))
  br label %return

if.then.88:                                       ; No predecessors!
  br label %return

if.end.89:                                        ; No predecessors!
  br label %while.cond.91

while.cond.91:                                    ; preds = %while.body.93, %if.end.89
  br label %while.end.95

while.body.93:                                    ; No predecessors!
  br label %while.cond.91

while.end.95:                                     ; preds = %while.cond.91
  br label %return

return:                                           ; preds = %if.end.83, %if.end.47, %if.then.13, %while.end.95, %if.then.88, %if.end.77, %if.end.57, %if.end.17, %if.then.16, %if.then.2, %if.then
  ret i8* undef

UnifiedUnreachableBlock:                          ; preds = %if.then.45, %if.then.8, %if.then.4
  unreachable
}

; Function Attrs: nounwind uwtable
define internal void @GlobalFree(i8* %p) {
entry:
  %p.addr = alloca i8*, align 8
  %pcom = alloca i64, align 8
  %ncom = alloca i64, align 8
  %pn = alloca %struct.node*, align 8
  %prev = alloca %struct.node*, align 8
  %curr = alloca %struct.node*, align 8
  %next = alloca %struct.node*, align 8
  br i1 undef, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  br label %return

if.end:                                           ; preds = %entry
  br i1 undef, label %if.then.1, label %if.end.2

if.then.1:                                        ; preds = %if.end
  br label %UnifiedUnreachableBlock

if.end.2:                                         ; preds = %if.end
  br i1 undef, label %if.then.4, label %if.end.6

if.then.4:                                        ; preds = %if.end.2
  br label %UnifiedUnreachableBlock

if.end.6:                                         ; preds = %if.end.2
  br i1 undef, label %if.then.9, label %if.end.30

if.then.9:                                        ; preds = %if.end.6
  br label %while.cond

while.cond:                                       ; preds = %if.end.21, %if.then.9
  br label %land.end

land.rhs:                                         ; No predecessors!
  br label %land.end

land.end:                                         ; preds = %while.cond, %land.rhs
  br i1 undef, label %while.body, label %while.end

while.body:                                       ; preds = %land.end
  br i1 undef, label %if.then.15, label %if.end.17

if.then.15:                                       ; preds = %while.body
  br label %UnifiedUnreachableBlock

if.end.17:                                        ; preds = %while.body
  br label %if.end.21

if.then.20:                                       ; No predecessors!
  br label %if.end.21

if.else:                                          ; No predecessors!
  br label %if.end.21

if.end.21:                                        ; preds = %if.end.17, %if.else, %if.then.20
  br label %while.cond

while.end:                                        ; preds = %land.end
  br i1 undef, label %if.then.24, label %if.end.29

if.then.24:                                       ; preds = %while.end
  br label %UnifiedUnreachableBlock

if.end.29:                                        ; preds = %while.end
  br label %if.end.30

if.end.30:                                        ; preds = %if.end.29, %if.end.6
  br label %while.cond.34

while.cond.34:                                    ; preds = %if.end.49, %if.end.30
  br label %land.end.38

land.rhs.36:                                      ; No predecessors!
  br label %land.end.38

land.end.38:                                      ; preds = %while.cond.34, %land.rhs.36
  br i1 undef, label %while.body.39, label %while.end.53

while.body.39:                                    ; preds = %land.end.38
  br i1 undef, label %if.then.42, label %if.end.44

if.then.42:                                       ; preds = %while.body.39
  br label %UnifiedUnreachableBlock

if.end.44:                                        ; preds = %while.body.39
  br label %if.end.49

if.then.47:                                       ; No predecessors!
  br label %if.end.49

if.else.48:                                       ; No predecessors!
  br label %if.end.49

if.end.49:                                        ; preds = %if.end.44, %if.else.48, %if.then.47
  br label %while.cond.34

while.end.53:                                     ; preds = %land.end.38
  br label %if.end.56

if.then.55:                                       ; No predecessors!
  br label %if.end.56

if.end.56:                                        ; preds = %while.end.53, %if.then.55
  br label %if.end.161

land.lhs.true:                                    ; No predecessors!
  br label %if.end.161

land.lhs.true.60:                                 ; No predecessors!
  br label %if.end.161

if.then.62:                                       ; No predecessors!
  br label %if.end.161

if.else.68:                                       ; No predecessors!
  br label %if.end.160

land.lhs.true.70:                                 ; No predecessors!
  br label %if.end.160

land.lhs.true.72:                                 ; No predecessors!
  br label %if.end.160

land.lhs.true.74:                                 ; No predecessors!
  br label %if.end.160

if.then.76:                                       ; No predecessors!
  br label %if.end.160

if.else.79:                                       ; No predecessors!
  br label %if.end.159

land.lhs.true.81:                                 ; No predecessors!
  br label %if.end.159

land.lhs.true.83:                                 ; No predecessors!
  br label %if.end.159

if.then.85:                                       ; No predecessors!
  br label %if.end.159

if.else.88:                                       ; No predecessors!
  br label %if.end.158

land.lhs.true.90:                                 ; No predecessors!
  br label %if.end.158

if.then.92:                                       ; No predecessors!
  br label %if.end.158

if.else.101:                                      ; No predecessors!
  br label %if.end.157

land.lhs.true.103:                                ; No predecessors!
  br label %if.end.157

land.lhs.true.105:                                ; No predecessors!
  br label %if.end.157

if.then.107:                                      ; No predecessors!
  br label %if.end.157

if.else.115:                                      ; No predecessors!
  br label %if.end.156

land.lhs.true.117:                                ; No predecessors!
  br label %if.end.156

if.then.119:                                      ; No predecessors!
  br label %if.end.156

if.else.127:                                      ; No predecessors!
  br label %if.end.155

land.lhs.true.129:                                ; No predecessors!
  br label %if.end.155

if.then.131:                                      ; No predecessors!
  br label %if.end.155

if.else.137:                                      ; No predecessors!
  br label %if.end.154

land.lhs.true.139:                                ; No predecessors!
  br label %if.end.154

land.lhs.true.141:                                ; No predecessors!
  br label %if.end.154

if.then.143:                                      ; No predecessors!
  br label %if.end.154

if.else.146:                                      ; No predecessors!
  br label %if.end.153

land.lhs.true.148:                                ; No predecessors!
  br label %if.end.153

if.then.150:                                      ; No predecessors!
  br label %if.end.153

if.end.153:                                       ; preds = %land.lhs.true.148, %if.else.146, %if.then.150
  br label %if.end.154

if.end.154:                                       ; preds = %land.lhs.true.141, %land.lhs.true.139, %if.else.137, %if.end.153, %if.then.143
  br label %if.end.155

if.end.155:                                       ; preds = %land.lhs.true.129, %if.else.127, %if.end.154, %if.then.131
  br label %if.end.156

if.end.156:                                       ; preds = %land.lhs.true.117, %if.else.115, %if.end.155, %if.then.119
  br label %if.end.157

if.end.157:                                       ; preds = %land.lhs.true.105, %land.lhs.true.103, %if.else.101, %if.end.156, %if.then.107
  br label %if.end.158

if.end.158:                                       ; preds = %land.lhs.true.90, %if.else.88, %if.end.157, %if.then.92
  br label %if.end.159

if.end.159:                                       ; preds = %land.lhs.true.83, %land.lhs.true.81, %if.else.79, %if.end.158, %if.then.85
  br label %if.end.160

if.end.160:                                       ; preds = %land.lhs.true.74, %land.lhs.true.72, %land.lhs.true.70, %if.else.68, %if.end.159, %if.then.76
  br label %if.end.161

if.end.161:                                       ; preds = %land.lhs.true.60, %land.lhs.true, %if.end.56, %if.end.160, %if.then.62
  br label %return

return:                                           ; preds = %if.end.161, %if.then
  ret void

UnifiedUnreachableBlock:                          ; preds = %if.then.42, %if.then.24, %if.then.15, %if.then.4, %if.then.1
  unreachable
}

; Function Attrs: nounwind uwtable
define internal i64 @GlobalMemAvl() {
entry:
  %total = alloca i64, align 8
  %curr = alloca %struct.node*, align 8
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  br label %while.end

while.body:                                       ; No predecessors!
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret i64 undef
}

; Function Attrs: nounwind uwtable
define internal i64 @GlobalMemMax() {
entry:
  %max = alloca i64, align 8
  %curr = alloca %struct.node*, align 8
  br label %while.cond

while.cond:                                       ; preds = %cond.end, %entry
  br label %while.end

while.body:                                       ; No predecessors!
  br label %cond.end

cond.true:                                        ; No predecessors!
  br label %cond.end

cond.false:                                       ; No predecessors!
  br label %cond.end

cond.end:                                         ; preds = %while.body, %cond.false, %cond.true
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret i64 undef
}

; Function Attrs: nounwind uwtable
define internal i8* @ObjectMalloc(i64 %ObjectType, i64 %count) {
entry:
  %ObjectType.addr = alloca i64, align 8
  %count.addr = alloca i64, align 8
  %n = alloca i64, align 8
  %p = alloca i8*, align 8
  %i = alloca i64, align 8
  %x = alloca %struct.voxel**, align 8
  %i21 = alloca i64, align 8
  %w = alloca i64, align 8
  %x22 = alloca i64*, align 8
  store i64 %ObjectType, i64* %ObjectType.addr, align 8
  store i64 %count, i64* %count.addr, align 8
  %0 = load i64* %ObjectType.addr, align 8
  switch i64 %0, label %sw.default [
    i64 0, label %sw.bb
    i64 1, label %sw.bb.1
    i64 2, label %sw.bb.10
    i64 3, label %sw.bb.20
    i64 6, label %sw.bb.39
    i64 7, label %sw.bb.48
  ]

sw.bb:                                            ; preds = %entry
  %1 = load i64* %count.addr, align 8
  %mul = mul i64 %1, 144
  store i64 %mul, i64* %n, align 8
  %2 = load i64* %n, align 8
  %call = call i8* @GlobalMalloc(i64 %2, i8* getelementptr inbounds ([5 x i8]* @.str.22.329, i32 0, i32 0))
  store i8* %call, i8** %p, align 8
  br label %cond.end

cond.true:                                        ; No predecessors!
  br label %cond.end

cond.false:                                       ; No predecessors!
  br label %cond.end

cond.end:                                         ; preds = %sw.bb, %cond.false, %cond.true
  br label %sw.epilog

sw.bb.1:                                          ; preds = %entry
  %3 = load i64* %count.addr, align 8
  %mul2 = mul i64 %3, 40
  store i64 %mul2, i64* %n, align 8
  %4 = load i64* %n, align 8
  %call3 = call i8* @GlobalMalloc(i64 %4, i8* getelementptr inbounds ([6 x i8]* @.str.23.330, i32 0, i32 0))
  store i8* %call3, i8** %p, align 8
  br label %cond.end.8

cond.true.6:                                      ; No predecessors!
  br label %cond.end.8

cond.false.7:                                     ; No predecessors!
  br label %cond.end.8

cond.end.8:                                       ; preds = %sw.bb.1, %cond.false.7, %cond.true.6
  br label %sw.epilog

sw.bb.10:                                         ; preds = %entry
  %5 = load i64* %count.addr, align 8
  %mul11 = mul i64 %5, 8
  store i64 %mul11, i64* %n, align 8
  %6 = load i64* %n, align 8
  %call12 = call i8* @GlobalMalloc(i64 %6, i8* getelementptr inbounds ([10 x i8]* @.str.24.331, i32 0, i32 0))
  store i8* %call12, i8** %p, align 8
  %7 = load i8** %p, align 8
  %8 = bitcast i8* %7 to %struct.voxel**
  store %struct.voxel** %8, %struct.voxel*** %x, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %sw.bb.10
  %9 = load i64* %i, align 8
  %10 = load i64* %count.addr, align 8
  %cmp13 = icmp slt i64 %9, %10
  br i1 %cmp13, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %11 = load i64* %i, align 8
  %12 = load %struct.voxel*** %x, align 8
  %arrayidx = getelementptr inbounds %struct.voxel** %12, i64 %11
  store %struct.voxel* null, %struct.voxel** %arrayidx, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %13 = load i64* %i, align 8
  %inc = add nsw i64 %13, 1
  store i64 %inc, i64* %i, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %cond.end.18

cond.true.16:                                     ; No predecessors!
  br label %cond.end.18

cond.false.17:                                    ; No predecessors!
  br label %cond.end.18

cond.end.18:                                      ; preds = %for.end, %cond.false.17, %cond.true.16
  br label %sw.epilog

sw.bb.20:                                         ; preds = %entry
  %14 = load i64* %count.addr, align 8
  %div = udiv i64 %14, 64
  %add23 = add i64 1, %div
  store i64 %add23, i64* %w, align 8
  %15 = load i64* %w, align 8
  %mul24 = mul i64 %15, 8
  store i64 %mul24, i64* %n, align 8
  %16 = load i64* %n, align 8
  %call25 = call i8* @GlobalMalloc(i64 %16, i8* getelementptr inbounds ([11 x i8]* @.str.25.332, i32 0, i32 0))
  store i8* %call25, i8** %p, align 8
  %17 = load i8** %p, align 8
  %18 = bitcast i8* %17 to i64*
  store i64* %18, i64** %x22, align 8
  store i64 0, i64* %i21, align 8
  br label %for.cond.26

for.cond.26:                                      ; preds = %for.inc.30, %sw.bb.20
  %19 = load i64* %i21, align 8
  %20 = load i64* %w, align 8
  %cmp27 = icmp slt i64 %19, %20
  br i1 %cmp27, label %for.body.28, label %for.end.32

for.body.28:                                      ; preds = %for.cond.26
  %21 = load i64* %i21, align 8
  %22 = load i64** %x22, align 8
  %arrayidx29 = getelementptr inbounds i64* %22, i64 %21
  store i64 -1, i64* %arrayidx29, align 8
  br label %for.inc.30

for.inc.30:                                       ; preds = %for.body.28
  %23 = load i64* %i21, align 8
  %inc31 = add nsw i64 %23, 1
  store i64 %inc31, i64* %i21, align 8
  br label %for.cond.26

for.end.32:                                       ; preds = %for.cond.26
  br label %cond.end.37

cond.true.35:                                     ; No predecessors!
  br label %cond.end.37

cond.false.36:                                    ; No predecessors!
  br label %cond.end.37

cond.end.37:                                      ; preds = %for.end.32, %cond.false.36, %cond.true.35
  br label %sw.epilog

sw.bb.39:                                         ; preds = %entry
  %24 = load i64* %count.addr, align 8
  %mul40 = mul i64 %24, 120
  store i64 %mul40, i64* %n, align 8
  %25 = load i64* %n, align 8
  %call41 = call i8* @GlobalMalloc(i64 %25, i8* getelementptr inbounds ([8 x i8]* @.str.26.333, i32 0, i32 0))
  store i8* %call41, i8** %p, align 8
  br label %cond.end.46

cond.true.44:                                     ; No predecessors!
  br label %cond.end.46

cond.false.45:                                    ; No predecessors!
  br label %cond.end.46

cond.end.46:                                      ; preds = %sw.bb.39, %cond.false.45, %cond.true.44
  br label %sw.epilog

sw.bb.48:                                         ; preds = %entry
  %26 = load i64* %count.addr, align 8
  %mul49 = mul i64 %26, 8
  store i64 %mul49, i64* %n, align 8
  %27 = load i64* %n, align 8
  %call50 = call i8* @GlobalMalloc(i64 %27, i8* getelementptr inbounds ([9 x i8]* @.str.27.334, i32 0, i32 0))
  store i8* %call50, i8** %p, align 8
  br label %cond.end.55

cond.true.53:                                     ; No predecessors!
  br label %cond.end.55

cond.false.54:                                    ; No predecessors!
  br label %cond.end.55

cond.end.55:                                      ; preds = %sw.bb.48, %cond.false.54, %cond.true.53
  br label %sw.epilog

sw.default:                                       ; preds = %entry
  unreachable

sw.epilog:                                        ; preds = %cond.end.55, %cond.end.46, %cond.end.37, %cond.end.18, %cond.end.8, %cond.end
  %28 = load i8** %p, align 8
  ret i8* %28
}

; Function Attrs: nounwind uwtable
define internal void @ObjectFree(i64 %ObjectType, i64 %count, i8* %p) {
entry:
  %ObjectType.addr = alloca i64, align 8
  %count.addr = alloca i64, align 8
  %p.addr = alloca i8*, align 8
  %n = alloca i64, align 8
  switch i64 undef, label %sw.default [
    i64 0, label %sw.bb
    i64 1, label %sw.bb.1
    i64 2, label %sw.bb.4
    i64 3, label %sw.bb.7
    i64 6, label %sw.bb.10
    i64 7, label %sw.bb.13
  ]

sw.bb:                                            ; preds = %entry
  br label %sw.epilog

sw.bb.1:                                          ; preds = %entry
  br label %sw.epilog

sw.bb.4:                                          ; preds = %entry
  br label %sw.epilog

sw.bb.7:                                          ; preds = %entry
  br label %sw.epilog

sw.bb.10:                                         ; preds = %entry
  br label %sw.epilog

sw.bb.13:                                         ; preds = %entry
  br label %sw.epilog

sw.default:                                       ; preds = %entry
  unreachable

sw.epilog:                                        ; preds = %sw.bb.13, %sw.bb.10, %sw.bb.7, %sw.bb.4, %sw.bb.1, %sw.bb
  ret void
}

; Function Attrs: nounwind uwtable
define internal %struct.rayinfo* @ma_rayinfo(%struct.ray* %r) {
entry:
  %r.addr = alloca %struct.ray*, align 8
  %p = alloca %struct.rayinfo*, align 8
  br i1 undef, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  unreachable

if.end:                                           ; preds = %entry
  ret %struct.rayinfo* undef
}

; Function Attrs: nounwind uwtable
define internal void @free_rayinfo(%struct.ray* %r) {
entry:
  %r.addr = alloca %struct.ray*, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @reset_rayinfo(%struct.ray* %r) {
entry:
  %r.addr = alloca %struct.ray*, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @ma_print() {
entry:
  %i = alloca i64, align 8
  %mem_total = alloca i64, align 8
  %maxmem_total = alloca i64, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal i8* @PolyName() {
entry:
  ret i8* getelementptr inbounds ([5 x i8]* @.str.366, i32 0, i32 0)
}

; Function Attrs: nounwind uwtable
define internal void @PolyPrint(%struct.object* %po) {
entry:
  %po.addr = alloca %struct.object*, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %vindex = alloca i64*, align 8
  %vlist = alloca [3 x double]*, align 8
  %vptr = alloca [3 x double]*, align 8
  %pp = alloca %struct.poly*, align 8
  %pe = alloca %struct.element*, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc.18, %entry
  br label %for.end.20

for.body:                                         ; No predecessors!
  br label %for.cond.9

for.cond.9:                                       ; preds = %for.inc, %for.body
  br label %for.end

for.body.12:                                      ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body.12
  br label %for.cond.9

for.end:                                          ; preds = %for.cond.9
  br label %for.inc.18

for.inc.18:                                       ; preds = %for.end
  br label %for.cond

for.end.20:                                       ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @PolyElementBoundBox(%struct.element* %pe, %struct.poly* %pp) {
entry:
  %pe.addr = alloca %struct.element*, align 8
  %pp.addr = alloca %struct.poly*, align 8
  %i = alloca i64, align 8
  %vindex = alloca i64*, align 8
  %pbb = alloca %struct.bbox*, align 8
  %vlist = alloca [3 x double]*, align 8
  %vptr = alloca [3 x double]*, align 8
  %minx = alloca double, align 8
  %maxx = alloca double, align 8
  %miny = alloca double, align 8
  %maxy = alloca double, align 8
  %minz = alloca double, align 8
  %maxz = alloca double, align 8
  store %struct.element* %pe, %struct.element** %pe.addr, align 8
  store %struct.poly* %pp, %struct.poly** %pp.addr, align 8
  %0 = load %struct.element** %pe.addr, align 8
  %bv = getelementptr inbounds %struct.element* %0, i32 0, i32 1
  store %struct.bbox* %bv, %struct.bbox** %pbb, align 8
  store double 1.000000e+32, double* %minz, align 8
  store double 1.000000e+32, double* %miny, align 8
  store double 1.000000e+32, double* %minx, align 8
  store double -1.000000e+32, double* %maxz, align 8
  store double -1.000000e+32, double* %maxy, align 8
  store double -1.000000e+32, double* %maxx, align 8
  %1 = load %struct.poly** %pp.addr, align 8
  %vptr1 = getelementptr inbounds %struct.poly* %1, i32 0, i32 3
  %2 = load [3 x double]** %vptr1, align 8
  store [3 x double]* %2, [3 x double]** %vlist, align 8
  %3 = load %struct.poly** %pp.addr, align 8
  %vindex2 = getelementptr inbounds %struct.poly* %3, i32 0, i32 4
  %4 = load i64** %vindex2, align 8
  store i64* %4, i64** %vindex, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %5 = load i64* %i, align 8
  %6 = load %struct.poly** %pp.addr, align 8
  %nverts = getelementptr inbounds %struct.poly* %6, i32 0, i32 0
  %7 = load i64* %nverts, align 8
  %cmp = icmp slt i64 %5, %7
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %8 = load [3 x double]** %vlist, align 8
  %9 = load i64** %vindex, align 8
  %10 = load i64* %9, align 8
  %add.ptr = getelementptr inbounds [3 x double]* %8, i64 %10
  store [3 x double]* %add.ptr, [3 x double]** %vptr, align 8
  %11 = load double* %minx, align 8
  %12 = load [3 x double]** %vptr, align 8
  %arrayidx = getelementptr inbounds [3 x double]* %12, i32 0, i64 0
  %13 = load double* %arrayidx, align 8
  %cmp3 = fcmp olt double %11, %13
  br i1 %cmp3, label %cond.true, label %cond.false

cond.true:                                        ; preds = %for.body
  %14 = load double* %minx, align 8
  br label %cond.end

cond.false:                                       ; preds = %for.body
  %15 = load [3 x double]** %vptr, align 8
  %arrayidx4 = getelementptr inbounds [3 x double]* %15, i32 0, i64 0
  %16 = load double* %arrayidx4, align 8
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi double [ %14, %cond.true ], [ %16, %cond.false ]
  store double %cond, double* %minx, align 8
  %17 = load double* %miny, align 8
  %18 = load [3 x double]** %vptr, align 8
  %arrayidx5 = getelementptr inbounds [3 x double]* %18, i32 0, i64 1
  %19 = load double* %arrayidx5, align 8
  %cmp6 = fcmp olt double %17, %19
  br i1 %cmp6, label %cond.true.7, label %cond.false.8

cond.true.7:                                      ; preds = %cond.end
  %20 = load double* %miny, align 8
  br label %cond.end.10

cond.false.8:                                     ; preds = %cond.end
  %21 = load [3 x double]** %vptr, align 8
  %arrayidx9 = getelementptr inbounds [3 x double]* %21, i32 0, i64 1
  %22 = load double* %arrayidx9, align 8
  br label %cond.end.10

cond.end.10:                                      ; preds = %cond.false.8, %cond.true.7
  %cond11 = phi double [ %20, %cond.true.7 ], [ %22, %cond.false.8 ]
  store double %cond11, double* %miny, align 8
  %23 = load double* %minz, align 8
  %24 = load [3 x double]** %vptr, align 8
  %arrayidx12 = getelementptr inbounds [3 x double]* %24, i32 0, i64 2
  %25 = load double* %arrayidx12, align 8
  %cmp13 = fcmp olt double %23, %25
  br i1 %cmp13, label %cond.true.14, label %cond.false.15

cond.true.14:                                     ; preds = %cond.end.10
  %26 = load double* %minz, align 8
  br label %cond.end.17

cond.false.15:                                    ; preds = %cond.end.10
  %27 = load [3 x double]** %vptr, align 8
  %arrayidx16 = getelementptr inbounds [3 x double]* %27, i32 0, i64 2
  %28 = load double* %arrayidx16, align 8
  br label %cond.end.17

cond.end.17:                                      ; preds = %cond.false.15, %cond.true.14
  %cond18 = phi double [ %26, %cond.true.14 ], [ %28, %cond.false.15 ]
  store double %cond18, double* %minz, align 8
  %29 = load double* %maxx, align 8
  %30 = load [3 x double]** %vptr, align 8
  %arrayidx19 = getelementptr inbounds [3 x double]* %30, i32 0, i64 0
  %31 = load double* %arrayidx19, align 8
  %cmp20 = fcmp ogt double %29, %31
  br i1 %cmp20, label %cond.true.21, label %cond.false.22

cond.true.21:                                     ; preds = %cond.end.17
  %32 = load double* %maxx, align 8
  br label %cond.end.24

cond.false.22:                                    ; preds = %cond.end.17
  %33 = load [3 x double]** %vptr, align 8
  %arrayidx23 = getelementptr inbounds [3 x double]* %33, i32 0, i64 0
  %34 = load double* %arrayidx23, align 8
  br label %cond.end.24

cond.end.24:                                      ; preds = %cond.false.22, %cond.true.21
  %cond25 = phi double [ %32, %cond.true.21 ], [ %34, %cond.false.22 ]
  store double %cond25, double* %maxx, align 8
  %35 = load double* %maxy, align 8
  %36 = load [3 x double]** %vptr, align 8
  %arrayidx26 = getelementptr inbounds [3 x double]* %36, i32 0, i64 1
  %37 = load double* %arrayidx26, align 8
  %cmp27 = fcmp ogt double %35, %37
  br i1 %cmp27, label %cond.true.28, label %cond.false.29

cond.true.28:                                     ; preds = %cond.end.24
  %38 = load double* %maxy, align 8
  br label %cond.end.31

cond.false.29:                                    ; preds = %cond.end.24
  %39 = load [3 x double]** %vptr, align 8
  %arrayidx30 = getelementptr inbounds [3 x double]* %39, i32 0, i64 1
  %40 = load double* %arrayidx30, align 8
  br label %cond.end.31

cond.end.31:                                      ; preds = %cond.false.29, %cond.true.28
  %cond32 = phi double [ %38, %cond.true.28 ], [ %40, %cond.false.29 ]
  store double %cond32, double* %maxy, align 8
  %41 = load double* %maxz, align 8
  %42 = load [3 x double]** %vptr, align 8
  %arrayidx33 = getelementptr inbounds [3 x double]* %42, i32 0, i64 2
  %43 = load double* %arrayidx33, align 8
  %cmp34 = fcmp ogt double %41, %43
  br i1 %cmp34, label %cond.true.35, label %cond.false.36

cond.true.35:                                     ; preds = %cond.end.31
  %44 = load double* %maxz, align 8
  br label %cond.end.38

cond.false.36:                                    ; preds = %cond.end.31
  %45 = load [3 x double]** %vptr, align 8
  %arrayidx37 = getelementptr inbounds [3 x double]* %45, i32 0, i64 2
  %46 = load double* %arrayidx37, align 8
  br label %cond.end.38

cond.end.38:                                      ; preds = %cond.false.36, %cond.true.35
  %cond39 = phi double [ %44, %cond.true.35 ], [ %46, %cond.false.36 ]
  store double %cond39, double* %maxz, align 8
  %47 = load i64** %vindex, align 8
  %incdec.ptr = getelementptr inbounds i64* %47, i32 1
  store i64* %incdec.ptr, i64** %vindex, align 8
  br label %for.inc

for.inc:                                          ; preds = %cond.end.38
  %48 = load i64* %i, align 8
  %inc = add nsw i64 %48, 1
  store i64 %inc, i64* %i, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %49 = load double* %minx, align 8
  %50 = load %struct.bbox** %pbb, align 8
  %dnear = getelementptr inbounds %struct.bbox* %50, i32 0, i32 0
  %arrayidx40 = getelementptr inbounds [3 x double]* %dnear, i32 0, i64 0
  store double %49, double* %arrayidx40, align 8
  %51 = load double* %miny, align 8
  %52 = load %struct.bbox** %pbb, align 8
  %dnear41 = getelementptr inbounds %struct.bbox* %52, i32 0, i32 0
  %arrayidx42 = getelementptr inbounds [3 x double]* %dnear41, i32 0, i64 1
  store double %51, double* %arrayidx42, align 8
  %53 = load double* %minz, align 8
  %54 = load %struct.bbox** %pbb, align 8
  %dnear43 = getelementptr inbounds %struct.bbox* %54, i32 0, i32 0
  %arrayidx44 = getelementptr inbounds [3 x double]* %dnear43, i32 0, i64 2
  store double %53, double* %arrayidx44, align 8
  %55 = load double* %maxx, align 8
  %56 = load %struct.bbox** %pbb, align 8
  %dfar = getelementptr inbounds %struct.bbox* %56, i32 0, i32 1
  %arrayidx45 = getelementptr inbounds [3 x double]* %dfar, i32 0, i64 0
  store double %55, double* %arrayidx45, align 8
  %57 = load double* %maxy, align 8
  %58 = load %struct.bbox** %pbb, align 8
  %dfar46 = getelementptr inbounds %struct.bbox* %58, i32 0, i32 1
  %arrayidx47 = getelementptr inbounds [3 x double]* %dfar46, i32 0, i64 1
  store double %57, double* %arrayidx47, align 8
  %59 = load double* %maxz, align 8
  %60 = load %struct.bbox** %pbb, align 8
  %dfar48 = getelementptr inbounds %struct.bbox* %60, i32 0, i32 1
  %arrayidx49 = getelementptr inbounds [3 x double]* %dfar48, i32 0, i64 2
  store double %59, double* %arrayidx49, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @PolyBoundBox(%struct.object* %po) {
entry:
  %po.addr = alloca %struct.object*, align 8
  %i = alloca i64, align 8
  %pp = alloca %struct.poly*, align 8
  %pe = alloca %struct.element*, align 8
  %pbb = alloca %struct.bbox*, align 8
  %minx = alloca double, align 8
  %maxx = alloca double, align 8
  %miny = alloca double, align 8
  %maxy = alloca double, align 8
  %minz = alloca double, align 8
  %maxz = alloca double, align 8
  store %struct.object* %po, %struct.object** %po.addr, align 8
  %0 = load %struct.object** %po.addr, align 8
  %pelem = getelementptr inbounds %struct.object* %0, i32 0, i32 3
  %1 = load %struct.element** %pelem, align 8
  store %struct.element* %1, %struct.element** %pe, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %2 = load i64* %i, align 8
  %3 = load %struct.object** %po.addr, align 8
  %numelements = getelementptr inbounds %struct.object* %3, i32 0, i32 4
  %4 = load i64* %numelements, align 8
  %cmp = icmp slt i64 %2, %4
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %5 = load %struct.element** %pe, align 8
  %data = getelementptr inbounds %struct.element* %5, i32 0, i32 3
  %6 = load i8** %data, align 8
  %7 = bitcast i8* %6 to %struct.poly*
  store %struct.poly* %7, %struct.poly** %pp, align 8
  %8 = load %struct.element** %pe, align 8
  %9 = load %struct.poly** %pp, align 8
  call void @PolyElementBoundBox(%struct.element* %8, %struct.poly* %9)
  br label %cond.end

cond.true:                                        ; No predecessors!
  br label %cond.end

cond.false:                                       ; No predecessors!
  br label %cond.end

cond.end:                                         ; preds = %for.body, %cond.false, %cond.true
  br label %cond.end.15

cond.true.10:                                     ; No predecessors!
  br label %cond.end.15

cond.false.11:                                    ; No predecessors!
  br label %cond.end.15

cond.end.15:                                      ; preds = %cond.end, %cond.false.11, %cond.true.10
  br label %cond.end.26

cond.true.21:                                     ; No predecessors!
  br label %cond.end.26

cond.false.22:                                    ; No predecessors!
  br label %cond.end.26

cond.end.26:                                      ; preds = %cond.end.15, %cond.false.22, %cond.true.21
  br label %cond.end.36

cond.true.31:                                     ; No predecessors!
  br label %cond.end.36

cond.false.32:                                    ; No predecessors!
  br label %cond.end.36

cond.end.36:                                      ; preds = %cond.end.26, %cond.false.32, %cond.true.31
  br label %cond.end.47

cond.true.42:                                     ; No predecessors!
  br label %cond.end.47

cond.false.43:                                    ; No predecessors!
  br label %cond.end.47

cond.end.47:                                      ; preds = %cond.end.36, %cond.false.43, %cond.true.42
  br label %cond.end.58

cond.true.53:                                     ; No predecessors!
  br label %cond.end.58

cond.false.54:                                    ; No predecessors!
  br label %cond.end.58

cond.end.58:                                      ; preds = %cond.end.47, %cond.false.54, %cond.true.53
  %10 = load %struct.element** %pe, align 8
  %incdec.ptr = getelementptr inbounds %struct.element* %10, i32 1
  store %struct.element* %incdec.ptr, %struct.element** %pe, align 8
  br label %for.inc

for.inc:                                          ; preds = %cond.end.58
  %11 = load i64* %i, align 8
  %inc = add nsw i64 %11, 1
  store i64 %inc, i64* %i, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @PolyNormal(%struct.irecord* %hit, double* %Pi, double* %Ni) {
entry:
  %hit.addr = alloca %struct.irecord*, align 8
  %Pi.addr = alloca double*, align 8
  %Ni.addr = alloca double*, align 8
  %pe = alloca %struct.element*, align 8
  %pp = alloca %struct.poly*, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @PolyDataNormalize(%struct.object* %po, [4 x double]* %normMat) {
entry:
  %po.addr = alloca %struct.object*, align 8
  %normMat.addr = alloca [4 x double]*, align 8
  %i = alloca i64, align 8
  %coord = alloca [4 x double], align 16
  %pv = alloca [3 x double]*, align 8
  %pp = alloca %struct.poly*, align 8
  %pe = alloca %struct.element*, align 8
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  br label %land.end

land.lhs.true:                                    ; No predecessors!
  br label %land.end

land.rhs:                                         ; No predecessors!
  br label %land.end

land.end:                                         ; preds = %land.lhs.true, %while.cond, %land.rhs
  br label %while.end

while.body:                                       ; No predecessors!
  br label %while.cond

while.end:                                        ; preds = %land.end
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %while.end
  br label %for.end

for.body:                                         ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal i64 @PolyPeIntersect(%struct.ray* %pr, %struct.element* %pe, %struct.irecord* %hit) {
entry:
  %retval = alloca i64, align 8
  %pr.addr = alloca %struct.ray*, align 8
  %pe.addr = alloca %struct.element*, align 8
  %hit.addr = alloca %struct.irecord*, align 8
  %i = alloca i64, align 8
  %vindex = alloca i64*, align 8
  %toright = alloca i64, align 8
  %sh = alloca i64, align 8
  %nsh = alloca i64, align 8
  %tmp = alloca double, align 8
  %Rd_dot_Pn = alloca double, align 8
  %Ro_dot_Pn = alloca double, align 8
  %q1 = alloca double, align 8
  %q2 = alloca double, align 8
  %tval = alloca double, align 8
  %x = alloca [101 x double], align 16
  %y = alloca [101 x double], align 16
  %ix = alloca double, align 8
  %iy = alloca double, align 8
  %dx = alloca double, align 8
  %dy = alloca double, align 8
  %xint = alloca double, align 8
  %I = alloca [3 x double], align 16
  %vlist = alloca [3 x double]*, align 8
  %vpos = alloca [3 x double]*, align 8
  %v1 = alloca [3 x double]*, align 8
  %v2 = alloca [3 x double]*, align 8
  %v3 = alloca [3 x double]*, align 8
  %pp = alloca %struct.poly*, align 8
  br label %cond.end

cond.true:                                        ; No predecessors!
  br label %cond.end

cond.false:                                       ; No predecessors!
  br label %cond.end

cond.end:                                         ; preds = %entry, %cond.false, %cond.true
  br label %return

if.then:                                          ; No predecessors!
  br label %return

if.end:                                           ; No predecessors!
  br label %return

if.then.52:                                       ; No predecessors!
  br label %return

if.end.53:                                        ; No predecessors!
  br label %sw.epilog

sw.bb:                                            ; No predecessors!
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %sw.bb
  br label %for.end

for.body:                                         ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %sw.epilog

sw.bb.83:                                         ; No predecessors!
  br label %for.cond.84

for.cond.84:                                      ; preds = %for.inc.94, %sw.bb.83
  br label %for.end.96

for.body.87:                                      ; No predecessors!
  br label %for.inc.94

for.inc.94:                                       ; preds = %for.body.87
  br label %for.cond.84

for.end.96:                                       ; preds = %for.cond.84
  br label %sw.epilog

sw.bb.99:                                         ; No predecessors!
  br label %for.cond.100

for.cond.100:                                     ; preds = %for.inc.110, %sw.bb.99
  br label %for.end.112

for.body.103:                                     ; No predecessors!
  br label %for.inc.110

for.inc.110:                                      ; preds = %for.body.103
  br label %for.cond.100

for.end.112:                                      ; preds = %for.cond.100
  br label %sw.epilog

sw.epilog:                                        ; preds = %if.end.53, %for.end.112, %for.end.96, %for.end
  br label %for.cond.115

for.cond.115:                                     ; preds = %for.inc.136, %sw.epilog
  br label %for.end.138

for.body.118:                                     ; No predecessors!
  br label %cond.end.130

cond.true.125:                                    ; No predecessors!
  br label %cond.end.130

cond.false.127:                                   ; No predecessors!
  br label %cond.end.130

cond.end.130:                                     ; preds = %for.body.118, %cond.false.127, %cond.true.125
  br label %if.end.135

if.then.133:                                      ; No predecessors!
  br label %if.end.135

if.end.135:                                       ; preds = %cond.end.130, %if.then.133
  br label %for.inc.136

for.inc.136:                                      ; preds = %if.end.135
  br label %for.cond.115

for.end.138:                                      ; preds = %for.cond.115
  br label %if.end.148

if.then.147:                                      ; No predecessors!
  br label %if.end.148

if.else:                                          ; No predecessors!
  br label %if.end.148

if.end.148:                                       ; preds = %for.end.138, %if.else, %if.then.147
  br label %for.cond.149

for.cond.149:                                     ; preds = %for.inc.187, %if.end.148
  br label %for.end.189

for.body.152:                                     ; No predecessors!
  br label %if.end.158

if.then.156:                                      ; No predecessors!
  br label %if.end.158

if.else.157:                                      ; No predecessors!
  br label %if.end.158

if.end.158:                                       ; preds = %for.body.152, %if.else.157, %if.then.156
  br label %if.end.186

if.then.159:                                      ; No predecessors!
  br label %cond.end.168

cond.true.165:                                    ; No predecessors!
  br label %cond.end.168

cond.false.166:                                   ; No predecessors!
  br label %cond.end.168

cond.end.168:                                     ; preds = %if.then.159, %cond.false.166, %cond.true.165
  br label %if.end.185

if.then.171:                                      ; No predecessors!
  br label %if.end.184

if.then.182:                                      ; No predecessors!
  br label %if.end.184

if.end.184:                                       ; preds = %if.then.171, %if.then.182
  br label %if.end.185

if.end.185:                                       ; preds = %cond.end.168, %if.end.184
  br label %if.end.186

if.end.186:                                       ; preds = %if.end.158, %if.end.185
  br label %for.inc.187

for.inc.187:                                      ; preds = %if.end.186
  br label %for.cond.149

for.end.189:                                      ; preds = %for.cond.149
  br label %return

if.then.191:                                      ; No predecessors!
  br label %return

if.else.192:                                      ; No predecessors!
  br label %return

return:                                           ; preds = %for.end.189, %if.end, %cond.end, %if.else.192, %if.then.191, %if.then.52, %if.then
  ret i64 undef
}

; Function Attrs: nounwind uwtable
define internal i64 @PolyIntersect(%struct.ray* %pr, %struct.object* %po, %struct.irecord* %hit) {
entry:
  %pr.addr = alloca %struct.ray*, align 8
  %po.addr = alloca %struct.object*, align 8
  %hit.addr = alloca %struct.irecord*, align 8
  %i = alloca i64, align 8
  %nhits = alloca i64, align 8
  %pe = alloca %struct.element*, align 8
  %newhit = alloca %struct.irecord, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br label %for.end

for.body:                                         ; No predecessors!
  br label %if.end.12

if.then:                                          ; No predecessors!
  br label %if.end

if.then.5:                                        ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %if.then, %if.then.5
  br label %if.end.12

if.end.12:                                        ; preds = %for.body, %if.end
  br label %for.inc

for.inc:                                          ; preds = %if.end.12
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i64 undef
}

; Function Attrs: nounwind uwtable
define internal void @PolyTransform(%struct.object* %po, [4 x double]* %xtrans, [4 x double]* %xinvT) {
entry:
  %po.addr = alloca %struct.object*, align 8
  %xtrans.addr = alloca [4 x double]*, align 8
  %xinvT.addr = alloca [4 x double]*, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %numelems = alloca i64, align 8
  %vindex = alloca i64*, align 8
  %vptr = alloca [3 x double]*, align 8
  %vp = alloca [3 x double]*, align 8
  %norm = alloca [4 x double], align 16
  %coord = alloca [4 x double], align 16
  %pp = alloca %struct.poly*, align 8
  %pe = alloca %struct.element*, align 8
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  br label %land.end

land.lhs.true:                                    ; No predecessors!
  br label %land.end

land.rhs:                                         ; No predecessors!
  br label %land.end

land.end:                                         ; preds = %land.lhs.true, %while.cond, %land.rhs
  br label %while.end

while.body:                                       ; No predecessors!
  br label %while.cond

while.end:                                        ; preds = %land.end
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %while.end
  br label %for.end

for.body:                                         ; No predecessors!
  br label %cond.end

cond.true:                                        ; No predecessors!
  br label %cond.end

cond.false:                                       ; No predecessors!
  br label %cond.end

cond.end:                                         ; preds = %for.body, %cond.false, %cond.true
  br label %cond.end.84

cond.true.77:                                     ; No predecessors!
  br label %cond.end.84

cond.false.80:                                    ; No predecessors!
  br label %cond.end.84

cond.end.84:                                      ; preds = %cond.end, %cond.false.80, %cond.true.77
  br label %cond.end.97

cond.true.90:                                     ; No predecessors!
  br label %cond.end.97

cond.false.93:                                    ; No predecessors!
  br label %cond.end.97

cond.end.97:                                      ; preds = %cond.end.84, %cond.false.93, %cond.true.90
  br label %if.end.118

land.lhs.true.103:                                ; No predecessors!
  br label %if.end.118

if.then:                                          ; No predecessors!
  br label %if.end.118

if.else:                                          ; No predecessors!
  br label %if.end

land.lhs.true.110:                                ; No predecessors!
  br label %if.end

if.then.114:                                      ; No predecessors!
  br label %if.end

if.else.116:                                      ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %land.lhs.true.110, %if.else, %if.else.116, %if.then.114
  br label %if.end.118

if.end.118:                                       ; preds = %land.lhs.true.103, %cond.end.97, %if.end, %if.then
  br label %for.inc

for.inc:                                          ; preds = %if.end.118
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @PolyRead(%struct.object* %po, %struct._IO_FILE* %pf) {
entry:
  %po.addr = alloca %struct.object*, align 8
  %pf.addr = alloca %struct._IO_FILE*, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %instat = alloca i64, align 8
  %vindex = alloca i64*, align 8
  %totalverts = alloca i64, align 8
  %normstr = alloca [5 x i8], align 1
  %pnormals = alloca i64, align 8
  %vnormals = alloca i64, align 8
  %pnorm = alloca [3 x double], align 16
  %vlist = alloca [3 x double]*, align 8
  %vptr = alloca [3 x double]*, align 8
  %vp = alloca [3 x double]*, align 8
  %vptmp = alloca [3 x double]*, align 8
  %vptmp2 = alloca [3 x double]*, align 8
  %tmppnt = alloca [3 x double], align 16
  %tmppnt2 = alloca [3 x double], align 16
  %cross = alloca [3 x double], align 16
  %pp = alloca %struct.poly*, align 8
  %pe = alloca %struct.element*, align 8
  store %struct.object* %po, %struct.object** %po.addr, align 8
  store %struct._IO_FILE* %pf, %struct._IO_FILE** %pf.addr, align 8
  %0 = load %struct.object** %po.addr, align 8
  %pelem = getelementptr inbounds %struct.object* %0, i32 0, i32 3
  %1 = load %struct.element** %pelem, align 8
  store %struct.element* %1, %struct.element** %pe, align 8
  %2 = load %struct._IO_FILE** %pf.addr, align 8
  %call = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %2, i8* getelementptr inbounds ([4 x i8]* @.str.4.370, i32 0, i32 0), i64* %totalverts)
  %conv = sext i32 %call to i64
  store i64 %conv, i64* %instat, align 8
  %3 = load i64* %instat, align 8
  %cmp = icmp ne i64 %3, 1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %UnifiedUnreachableBlock

if.end:                                           ; preds = %entry
  %4 = load %struct.object** %po.addr, align 8
  %numelements = getelementptr inbounds %struct.object* %4, i32 0, i32 4
  %5 = load i64* %numelements, align 8
  %mul = mul i64 64, %5
  %call3 = call i8* @GlobalMalloc(i64 %mul, i8* getelementptr inbounds ([7 x i8]* @.str.6.372, i32 0, i32 0))
  %6 = bitcast i8* %call3 to %struct.poly*
  store %struct.poly* %6, %struct.poly** %pp, align 8
  %7 = load i64* %totalverts, align 8
  %add = add nsw i64 %7, 1
  %mul4 = mul i64 24, %add
  %call5 = call i8* @GlobalMalloc(i64 %mul4, i8* getelementptr inbounds ([7 x i8]* @.str.6.372, i32 0, i32 0))
  %8 = bitcast i8* %call5 to [3 x double]*
  store [3 x double]* %8, [3 x double]** %vlist, align 8
  %9 = load [3 x double]** %vlist, align 8
  store [3 x double]* %9, [3 x double]** %vptr, align 8
  %10 = load %struct._IO_FILE** %pf.addr, align 8
  %arraydecay = getelementptr inbounds [5 x i8]* %normstr, i32 0, i32 0
  %call6 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %10, i8* getelementptr inbounds ([4 x i8]* @.str.7.373, i32 0, i32 0), i8* %arraydecay)
  %conv7 = sext i32 %call6 to i64
  store i64 %conv7, i64* %instat, align 8
  %11 = load i64* %instat, align 8
  %cmp8 = icmp ne i64 %11, 1
  br i1 %cmp8, label %if.then.10, label %if.end.12

if.then.10:                                       ; preds = %if.end
  br label %UnifiedUnreachableBlock

if.end.12:                                        ; preds = %if.end
  %arrayidx = getelementptr inbounds [5 x i8]* %normstr, i32 0, i64 2
  %12 = load i8* %arrayidx, align 1
  %conv13 = sext i8 %12 to i32
  %cmp14 = icmp eq i32 %conv13, 121
  %cond = select i1 %cmp14, i32 1, i32 0
  %conv16 = sext i32 %cond to i64
  store i64 %conv16, i64* %pnormals, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end.12
  %13 = load i64* %i, align 8
  %14 = load i64* %totalverts, align 8
  %cmp17 = icmp slt i64 %13, %14
  br i1 %cmp17, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %15 = load %struct._IO_FILE** %pf.addr, align 8
  %16 = load [3 x double]** %vptr, align 8
  %arrayidx19 = getelementptr inbounds [3 x double]* %16, i32 0, i64 0
  %17 = load [3 x double]** %vptr, align 8
  %arrayidx20 = getelementptr inbounds [3 x double]* %17, i32 0, i64 1
  %18 = load [3 x double]** %vptr, align 8
  %arrayidx21 = getelementptr inbounds [3 x double]* %18, i32 0, i64 2
  %call22 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %15, i8* getelementptr inbounds ([12 x i8]* @.str.9.375, i32 0, i32 0), double* %arrayidx19, double* %arrayidx20, double* %arrayidx21)
  %conv23 = sext i32 %call22 to i64
  store i64 %conv23, i64* %instat, align 8
  %19 = load i64* %instat, align 8
  %cmp24 = icmp ne i64 %19, 3
  br i1 %cmp24, label %if.then.26, label %if.end.28

if.then.26:                                       ; preds = %for.body
  br label %UnifiedUnreachableBlock

if.end.28:                                        ; preds = %for.body
  %20 = load [3 x double]** %vptr, align 8
  %incdec.ptr = getelementptr inbounds [3 x double]* %20, i32 1
  store [3 x double]* %incdec.ptr, [3 x double]** %vptr, align 8
  br label %for.inc

for.inc:                                          ; preds = %if.end.28
  %21 = load i64* %i, align 8
  %inc = add nsw i64 %21, 1
  store i64 %inc, i64* %i, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %22 = load [3 x double]** %vptr, align 8
  %arrayidx29 = getelementptr inbounds [3 x double]* %22, i32 0, i64 0
  store double 1.000000e+32, double* %arrayidx29, align 8
  %23 = load [3 x double]** %vptr, align 8
  %arrayidx30 = getelementptr inbounds [3 x double]* %23, i32 0, i64 1
  store double 1.000000e+32, double* %arrayidx30, align 8
  %24 = load [3 x double]** %vptr, align 8
  %arrayidx31 = getelementptr inbounds [3 x double]* %24, i32 0, i64 2
  store double 1.000000e+32, double* %arrayidx31, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond.32

for.cond.32:                                      ; preds = %for.inc.362, %for.end
  %25 = load i64* %i, align 8
  %26 = load %struct.object** %po.addr, align 8
  %numelements33 = getelementptr inbounds %struct.object* %26, i32 0, i32 4
  %27 = load i64* %numelements33, align 8
  %cmp34 = icmp slt i64 %25, %27
  br i1 %cmp34, label %for.body.36, label %for.end.364

for.body.36:                                      ; preds = %for.cond.32
  %28 = load %struct._IO_FILE** %pf.addr, align 8
  %29 = load %struct.poly** %pp, align 8
  %nverts = getelementptr inbounds %struct.poly* %29, i32 0, i32 0
  %call37 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %28, i8* getelementptr inbounds ([4 x i8]* @.str.4.370, i32 0, i32 0), i64* %nverts)
  %conv38 = sext i32 %call37 to i64
  store i64 %conv38, i64* %instat, align 8
  %30 = load i64* %instat, align 8
  %cmp39 = icmp ne i64 %30, 1
  br i1 %cmp39, label %if.then.41, label %if.end.43

if.then.41:                                       ; preds = %for.body.36
  br label %UnifiedUnreachableBlock

if.end.43:                                        ; preds = %for.body.36
  %31 = load %struct.poly** %pp, align 8
  %nverts44 = getelementptr inbounds %struct.poly* %31, i32 0, i32 0
  %32 = load i64* %nverts44, align 8
  %cmp45 = icmp sgt i64 %32, 100
  br i1 %cmp45, label %if.then.47, label %if.end.50

if.then.47:                                       ; preds = %if.end.43
  br label %UnifiedUnreachableBlock

if.end.50:                                        ; preds = %if.end.43
  %33 = load i64* %pnormals, align 8
  %tobool = icmp ne i64 %33, 0
  br i1 %tobool, label %if.then.51, label %if.end.64

if.then.51:                                       ; preds = %if.end.50
  %34 = load %struct._IO_FILE** %pf.addr, align 8
  %35 = load %struct.poly** %pp, align 8
  %norm = getelementptr inbounds %struct.poly* %35, i32 0, i32 1
  %arrayidx52 = getelementptr inbounds [3 x double]* %norm, i32 0, i64 0
  %36 = load %struct.poly** %pp, align 8
  %norm53 = getelementptr inbounds %struct.poly* %36, i32 0, i32 1
  %arrayidx54 = getelementptr inbounds [3 x double]* %norm53, i32 0, i64 1
  %37 = load %struct.poly** %pp, align 8
  %norm55 = getelementptr inbounds %struct.poly* %37, i32 0, i32 1
  %arrayidx56 = getelementptr inbounds [3 x double]* %norm55, i32 0, i64 2
  %call57 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %34, i8* getelementptr inbounds ([13 x i8]* @.str.13.379, i32 0, i32 0), double* %arrayidx52, double* %arrayidx54, double* %arrayidx56)
  %conv58 = sext i32 %call57 to i64
  store i64 %conv58, i64* %instat, align 8
  %38 = load i64* %instat, align 8
  %cmp59 = icmp ne i64 %38, 3
  br i1 %cmp59, label %if.then.61, label %if.end.63

if.then.61:                                       ; preds = %if.then.51
  br label %UnifiedUnreachableBlock

if.end.63:                                        ; preds = %if.then.51
  br label %if.end.64

if.end.64:                                        ; preds = %if.end.63, %if.end.50
  %39 = load [3 x double]** %vlist, align 8
  %40 = load %struct.poly** %pp, align 8
  %vptr65 = getelementptr inbounds %struct.poly* %40, i32 0, i32 3
  store [3 x double]* %39, [3 x double]** %vptr65, align 8
  %41 = load %struct.poly** %pp, align 8
  %nverts66 = getelementptr inbounds %struct.poly* %41, i32 0, i32 0
  %42 = load i64* %nverts66, align 8
  %mul67 = mul i64 8, %42
  %call68 = call i8* @GlobalMalloc(i64 %mul67, i8* getelementptr inbounds ([7 x i8]* @.str.6.372, i32 0, i32 0))
  %43 = bitcast i8* %call68 to i64*
  %44 = load %struct.poly** %pp, align 8
  %vindex69 = getelementptr inbounds %struct.poly* %44, i32 0, i32 4
  store i64* %43, i64** %vindex69, align 8
  %45 = load %struct.poly** %pp, align 8
  %vindex70 = getelementptr inbounds %struct.poly* %45, i32 0, i32 4
  %46 = load i64** %vindex70, align 8
  store i64* %46, i64** %vindex, align 8
  store i64 0, i64* %j, align 8
  br label %for.cond.71

for.cond.71:                                      ; preds = %for.inc.84, %if.end.64
  %47 = load i64* %j, align 8
  %48 = load %struct.poly** %pp, align 8
  %nverts72 = getelementptr inbounds %struct.poly* %48, i32 0, i32 0
  %49 = load i64* %nverts72, align 8
  %cmp73 = icmp slt i64 %47, %49
  br i1 %cmp73, label %for.body.75, label %for.end.86

for.body.75:                                      ; preds = %for.cond.71
  %50 = load %struct._IO_FILE** %pf.addr, align 8
  %51 = load i64** %vindex, align 8
  %incdec.ptr76 = getelementptr inbounds i64* %51, i32 1
  store i64* %incdec.ptr76, i64** %vindex, align 8
  %call77 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %50, i8* getelementptr inbounds ([4 x i8]* @.str.4.370, i32 0, i32 0), i64* %51)
  %conv78 = sext i32 %call77 to i64
  store i64 %conv78, i64* %instat, align 8
  %52 = load i64* %instat, align 8
  %cmp79 = icmp ne i64 %52, 1
  br i1 %cmp79, label %if.then.81, label %if.end.83

if.then.81:                                       ; preds = %for.body.75
  br label %UnifiedUnreachableBlock

if.end.83:                                        ; preds = %for.body.75
  br label %for.inc.84

for.inc.84:                                       ; preds = %if.end.83
  %53 = load i64* %j, align 8
  %inc85 = add nsw i64 %53, 1
  store i64 %inc85, i64* %j, align 8
  br label %for.cond.71

for.end.86:                                       ; preds = %for.cond.71
  %54 = load %struct.poly** %pp, align 8
  %vindex87 = getelementptr inbounds %struct.poly* %54, i32 0, i32 4
  %55 = load i64** %vindex87, align 8
  store i64* %55, i64** %vindex, align 8
  %56 = load [3 x double]** %vlist, align 8
  store [3 x double]* %56, [3 x double]** %vptr, align 8
  %57 = load i64* %pnormals, align 8
  %tobool88 = icmp ne i64 %57, 0
  br i1 %tobool88, label %if.end.341, label %if.then.89

if.then.89:                                       ; preds = %for.end.86
  %58 = load [3 x double]** %vptr, align 8
  %59 = load i64** %vindex, align 8
  %60 = load i64* %59, align 8
  %add.ptr = getelementptr inbounds [3 x double]* %58, i64 %60
  store [3 x double]* %add.ptr, [3 x double]** %vp, align 8
  %arrayidx90 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 0
  store double 0.000000e+00, double* %arrayidx90, align 8
  %arrayidx91 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 1
  store double 0.000000e+00, double* %arrayidx91, align 8
  %arrayidx92 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 2
  store double 0.000000e+00, double* %arrayidx92, align 8
  store i64 0, i64* %j, align 8
  br label %for.cond.93

for.cond.93:                                      ; preds = %for.inc.163, %if.then.89
  %61 = load i64* %j, align 8
  %62 = load %struct.poly** %pp, align 8
  %nverts94 = getelementptr inbounds %struct.poly* %62, i32 0, i32 0
  %63 = load i64* %nverts94, align 8
  %sub = sub nsw i64 %63, 2
  %cmp95 = icmp slt i64 %61, %sub
  br i1 %cmp95, label %for.body.97, label %for.end.165

for.body.97:                                      ; preds = %for.cond.93
  %64 = load [3 x double]** %vptr, align 8
  %65 = load i64** %vindex, align 8
  %add.ptr98 = getelementptr inbounds i64* %65, i64 1
  %66 = load i64* %add.ptr98, align 8
  %add.ptr99 = getelementptr inbounds [3 x double]* %64, i64 %66
  store [3 x double]* %add.ptr99, [3 x double]** %vptmp, align 8
  %67 = load [3 x double]** %vptr, align 8
  %68 = load i64** %vindex, align 8
  %add.ptr100 = getelementptr inbounds i64* %68, i64 2
  %69 = load i64* %add.ptr100, align 8
  %add.ptr101 = getelementptr inbounds [3 x double]* %67, i64 %69
  store [3 x double]* %add.ptr101, [3 x double]** %vptmp2, align 8
  %70 = load [3 x double]** %vptmp, align 8
  %arrayidx102 = getelementptr inbounds [3 x double]* %70, i32 0, i64 0
  %71 = load double* %arrayidx102, align 8
  %72 = load [3 x double]** %vp, align 8
  %arrayidx103 = getelementptr inbounds [3 x double]* %72, i32 0, i64 0
  %73 = load double* %arrayidx103, align 8
  %sub104 = fsub double %71, %73
  %arrayidx105 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 0
  store double %sub104, double* %arrayidx105, align 8
  %74 = load [3 x double]** %vptmp, align 8
  %arrayidx106 = getelementptr inbounds [3 x double]* %74, i32 0, i64 1
  %75 = load double* %arrayidx106, align 8
  %76 = load [3 x double]** %vp, align 8
  %arrayidx107 = getelementptr inbounds [3 x double]* %76, i32 0, i64 1
  %77 = load double* %arrayidx107, align 8
  %sub108 = fsub double %75, %77
  %arrayidx109 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 1
  store double %sub108, double* %arrayidx109, align 8
  %78 = load [3 x double]** %vptmp, align 8
  %arrayidx110 = getelementptr inbounds [3 x double]* %78, i32 0, i64 2
  %79 = load double* %arrayidx110, align 8
  %80 = load [3 x double]** %vp, align 8
  %arrayidx111 = getelementptr inbounds [3 x double]* %80, i32 0, i64 2
  %81 = load double* %arrayidx111, align 8
  %sub112 = fsub double %79, %81
  %arrayidx113 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 2
  store double %sub112, double* %arrayidx113, align 8
  %82 = load [3 x double]** %vptmp2, align 8
  %arrayidx114 = getelementptr inbounds [3 x double]* %82, i32 0, i64 0
  %83 = load double* %arrayidx114, align 8
  %84 = load [3 x double]** %vptmp, align 8
  %arrayidx115 = getelementptr inbounds [3 x double]* %84, i32 0, i64 0
  %85 = load double* %arrayidx115, align 8
  %sub116 = fsub double %83, %85
  %arrayidx117 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 0
  store double %sub116, double* %arrayidx117, align 8
  %86 = load [3 x double]** %vptmp2, align 8
  %arrayidx118 = getelementptr inbounds [3 x double]* %86, i32 0, i64 1
  %87 = load double* %arrayidx118, align 8
  %88 = load [3 x double]** %vptmp, align 8
  %arrayidx119 = getelementptr inbounds [3 x double]* %88, i32 0, i64 1
  %89 = load double* %arrayidx119, align 8
  %sub120 = fsub double %87, %89
  %arrayidx121 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 1
  store double %sub120, double* %arrayidx121, align 8
  %90 = load [3 x double]** %vptmp2, align 8
  %arrayidx122 = getelementptr inbounds [3 x double]* %90, i32 0, i64 2
  %91 = load double* %arrayidx122, align 8
  %92 = load [3 x double]** %vptmp, align 8
  %arrayidx123 = getelementptr inbounds [3 x double]* %92, i32 0, i64 2
  %93 = load double* %arrayidx123, align 8
  %sub124 = fsub double %91, %93
  %arrayidx125 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 2
  store double %sub124, double* %arrayidx125, align 8
  %arrayidx126 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 1
  %94 = load double* %arrayidx126, align 8
  %arrayidx127 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 2
  %95 = load double* %arrayidx127, align 8
  %mul128 = fmul double %94, %95
  %arrayidx129 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 2
  %96 = load double* %arrayidx129, align 8
  %arrayidx130 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 1
  %97 = load double* %arrayidx130, align 8
  %mul131 = fmul double %96, %97
  %sub132 = fsub double %mul128, %mul131
  %arrayidx133 = getelementptr inbounds [3 x double]* %cross, i32 0, i64 0
  store double %sub132, double* %arrayidx133, align 8
  %arrayidx134 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 2
  %98 = load double* %arrayidx134, align 8
  %arrayidx135 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 0
  %99 = load double* %arrayidx135, align 8
  %mul136 = fmul double %98, %99
  %arrayidx137 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 0
  %100 = load double* %arrayidx137, align 8
  %arrayidx138 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 2
  %101 = load double* %arrayidx138, align 8
  %mul139 = fmul double %100, %101
  %sub140 = fsub double %mul136, %mul139
  %arrayidx141 = getelementptr inbounds [3 x double]* %cross, i32 0, i64 1
  store double %sub140, double* %arrayidx141, align 8
  %arrayidx142 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 0
  %102 = load double* %arrayidx142, align 8
  %arrayidx143 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 1
  %103 = load double* %arrayidx143, align 8
  %mul144 = fmul double %102, %103
  %arrayidx145 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 1
  %104 = load double* %arrayidx145, align 8
  %arrayidx146 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 0
  %105 = load double* %arrayidx146, align 8
  %mul147 = fmul double %104, %105
  %sub148 = fsub double %mul144, %mul147
  %arrayidx149 = getelementptr inbounds [3 x double]* %cross, i32 0, i64 2
  store double %sub148, double* %arrayidx149, align 8
  %arrayidx150 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 0
  %106 = load double* %arrayidx150, align 8
  %arrayidx151 = getelementptr inbounds [3 x double]* %cross, i32 0, i64 0
  %107 = load double* %arrayidx151, align 8
  %add152 = fadd double %106, %107
  %arrayidx153 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 0
  store double %add152, double* %arrayidx153, align 8
  %arrayidx154 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 1
  %108 = load double* %arrayidx154, align 8
  %arrayidx155 = getelementptr inbounds [3 x double]* %cross, i32 0, i64 1
  %109 = load double* %arrayidx155, align 8
  %add156 = fadd double %108, %109
  %arrayidx157 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 1
  store double %add156, double* %arrayidx157, align 8
  %arrayidx158 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 2
  %110 = load double* %arrayidx158, align 8
  %arrayidx159 = getelementptr inbounds [3 x double]* %cross, i32 0, i64 2
  %111 = load double* %arrayidx159, align 8
  %add160 = fadd double %110, %111
  %arrayidx161 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 2
  store double %add160, double* %arrayidx161, align 8
  %112 = load [3 x double]** %vptmp, align 8
  store [3 x double]* %112, [3 x double]** %vp, align 8
  %113 = load i64** %vindex, align 8
  %add.ptr162 = getelementptr inbounds i64* %113, i64 1
  store i64* %add.ptr162, i64** %vindex, align 8
  br label %for.inc.163

for.inc.163:                                      ; preds = %for.body.97
  %114 = load i64* %j, align 8
  %inc164 = add nsw i64 %114, 1
  store i64 %inc164, i64* %j, align 8
  br label %for.cond.93

for.end.165:                                      ; preds = %for.cond.93
  %115 = load [3 x double]** %vptmp2, align 8
  %arrayidx166 = getelementptr inbounds [3 x double]* %115, i32 0, i64 0
  %116 = load double* %arrayidx166, align 8
  %117 = load [3 x double]** %vp, align 8
  %arrayidx167 = getelementptr inbounds [3 x double]* %117, i32 0, i64 0
  %118 = load double* %arrayidx167, align 8
  %sub168 = fsub double %116, %118
  %arrayidx169 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 0
  store double %sub168, double* %arrayidx169, align 8
  %119 = load [3 x double]** %vptmp2, align 8
  %arrayidx170 = getelementptr inbounds [3 x double]* %119, i32 0, i64 1
  %120 = load double* %arrayidx170, align 8
  %121 = load [3 x double]** %vp, align 8
  %arrayidx171 = getelementptr inbounds [3 x double]* %121, i32 0, i64 1
  %122 = load double* %arrayidx171, align 8
  %sub172 = fsub double %120, %122
  %arrayidx173 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 1
  store double %sub172, double* %arrayidx173, align 8
  %123 = load [3 x double]** %vptmp2, align 8
  %arrayidx174 = getelementptr inbounds [3 x double]* %123, i32 0, i64 2
  %124 = load double* %arrayidx174, align 8
  %125 = load [3 x double]** %vp, align 8
  %arrayidx175 = getelementptr inbounds [3 x double]* %125, i32 0, i64 2
  %126 = load double* %arrayidx175, align 8
  %sub176 = fsub double %124, %126
  %arrayidx177 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 2
  store double %sub176, double* %arrayidx177, align 8
  %127 = load %struct.poly** %pp, align 8
  %vindex178 = getelementptr inbounds %struct.poly* %127, i32 0, i32 4
  %128 = load i64** %vindex178, align 8
  store i64* %128, i64** %vindex, align 8
  %129 = load [3 x double]** %vptr, align 8
  %130 = load i64** %vindex, align 8
  %131 = load i64* %130, align 8
  %add.ptr179 = getelementptr inbounds [3 x double]* %129, i64 %131
  store [3 x double]* %add.ptr179, [3 x double]** %vp, align 8
  %132 = load [3 x double]** %vp, align 8
  %arrayidx180 = getelementptr inbounds [3 x double]* %132, i32 0, i64 0
  %133 = load double* %arrayidx180, align 8
  %134 = load [3 x double]** %vptmp2, align 8
  %arrayidx181 = getelementptr inbounds [3 x double]* %134, i32 0, i64 0
  %135 = load double* %arrayidx181, align 8
  %sub182 = fsub double %133, %135
  %arrayidx183 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 0
  store double %sub182, double* %arrayidx183, align 8
  %136 = load [3 x double]** %vp, align 8
  %arrayidx184 = getelementptr inbounds [3 x double]* %136, i32 0, i64 1
  %137 = load double* %arrayidx184, align 8
  %138 = load [3 x double]** %vptmp2, align 8
  %arrayidx185 = getelementptr inbounds [3 x double]* %138, i32 0, i64 1
  %139 = load double* %arrayidx185, align 8
  %sub186 = fsub double %137, %139
  %arrayidx187 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 1
  store double %sub186, double* %arrayidx187, align 8
  %140 = load [3 x double]** %vp, align 8
  %arrayidx188 = getelementptr inbounds [3 x double]* %140, i32 0, i64 2
  %141 = load double* %arrayidx188, align 8
  %142 = load [3 x double]** %vptmp2, align 8
  %arrayidx189 = getelementptr inbounds [3 x double]* %142, i32 0, i64 2
  %143 = load double* %arrayidx189, align 8
  %sub190 = fsub double %141, %143
  %arrayidx191 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 2
  store double %sub190, double* %arrayidx191, align 8
  %arrayidx192 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 1
  %144 = load double* %arrayidx192, align 8
  %arrayidx193 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 2
  %145 = load double* %arrayidx193, align 8
  %mul194 = fmul double %144, %145
  %arrayidx195 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 2
  %146 = load double* %arrayidx195, align 8
  %arrayidx196 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 1
  %147 = load double* %arrayidx196, align 8
  %mul197 = fmul double %146, %147
  %sub198 = fsub double %mul194, %mul197
  %arrayidx199 = getelementptr inbounds [3 x double]* %cross, i32 0, i64 0
  store double %sub198, double* %arrayidx199, align 8
  %arrayidx200 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 2
  %148 = load double* %arrayidx200, align 8
  %arrayidx201 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 0
  %149 = load double* %arrayidx201, align 8
  %mul202 = fmul double %148, %149
  %arrayidx203 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 0
  %150 = load double* %arrayidx203, align 8
  %arrayidx204 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 2
  %151 = load double* %arrayidx204, align 8
  %mul205 = fmul double %150, %151
  %sub206 = fsub double %mul202, %mul205
  %arrayidx207 = getelementptr inbounds [3 x double]* %cross, i32 0, i64 1
  store double %sub206, double* %arrayidx207, align 8
  %arrayidx208 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 0
  %152 = load double* %arrayidx208, align 8
  %arrayidx209 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 1
  %153 = load double* %arrayidx209, align 8
  %mul210 = fmul double %152, %153
  %arrayidx211 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 1
  %154 = load double* %arrayidx211, align 8
  %arrayidx212 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 0
  %155 = load double* %arrayidx212, align 8
  %mul213 = fmul double %154, %155
  %sub214 = fsub double %mul210, %mul213
  %arrayidx215 = getelementptr inbounds [3 x double]* %cross, i32 0, i64 2
  store double %sub214, double* %arrayidx215, align 8
  %arrayidx216 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 0
  %156 = load double* %arrayidx216, align 8
  %arrayidx217 = getelementptr inbounds [3 x double]* %cross, i32 0, i64 0
  %157 = load double* %arrayidx217, align 8
  %add218 = fadd double %156, %157
  %arrayidx219 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 0
  store double %add218, double* %arrayidx219, align 8
  %arrayidx220 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 1
  %158 = load double* %arrayidx220, align 8
  %arrayidx221 = getelementptr inbounds [3 x double]* %cross, i32 0, i64 1
  %159 = load double* %arrayidx221, align 8
  %add222 = fadd double %158, %159
  %arrayidx223 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 1
  store double %add222, double* %arrayidx223, align 8
  %arrayidx224 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 2
  %160 = load double* %arrayidx224, align 8
  %arrayidx225 = getelementptr inbounds [3 x double]* %cross, i32 0, i64 2
  %161 = load double* %arrayidx225, align 8
  %add226 = fadd double %160, %161
  %arrayidx227 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 2
  store double %add226, double* %arrayidx227, align 8
  %162 = load [3 x double]** %vptr, align 8
  %163 = load i64** %vindex, align 8
  %164 = load i64* %163, align 8
  %add.ptr228 = getelementptr inbounds [3 x double]* %162, i64 %164
  store [3 x double]* %add.ptr228, [3 x double]** %vp, align 8
  %165 = load [3 x double]** %vp, align 8
  %arrayidx229 = getelementptr inbounds [3 x double]* %165, i32 0, i64 0
  %166 = load double* %arrayidx229, align 8
  %167 = load [3 x double]** %vptmp2, align 8
  %arrayidx230 = getelementptr inbounds [3 x double]* %167, i32 0, i64 0
  %168 = load double* %arrayidx230, align 8
  %sub231 = fsub double %166, %168
  %arrayidx232 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 0
  store double %sub231, double* %arrayidx232, align 8
  %169 = load [3 x double]** %vp, align 8
  %arrayidx233 = getelementptr inbounds [3 x double]* %169, i32 0, i64 1
  %170 = load double* %arrayidx233, align 8
  %171 = load [3 x double]** %vptmp2, align 8
  %arrayidx234 = getelementptr inbounds [3 x double]* %171, i32 0, i64 1
  %172 = load double* %arrayidx234, align 8
  %sub235 = fsub double %170, %172
  %arrayidx236 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 1
  store double %sub235, double* %arrayidx236, align 8
  %173 = load [3 x double]** %vp, align 8
  %arrayidx237 = getelementptr inbounds [3 x double]* %173, i32 0, i64 2
  %174 = load double* %arrayidx237, align 8
  %175 = load [3 x double]** %vptmp2, align 8
  %arrayidx238 = getelementptr inbounds [3 x double]* %175, i32 0, i64 2
  %176 = load double* %arrayidx238, align 8
  %sub239 = fsub double %174, %176
  %arrayidx240 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 2
  store double %sub239, double* %arrayidx240, align 8
  %177 = load [3 x double]** %vptr, align 8
  %178 = load i64** %vindex, align 8
  %add.ptr241 = getelementptr inbounds i64* %178, i64 1
  %179 = load i64* %add.ptr241, align 8
  %add.ptr242 = getelementptr inbounds [3 x double]* %177, i64 %179
  store [3 x double]* %add.ptr242, [3 x double]** %vptmp, align 8
  %180 = load [3 x double]** %vptmp, align 8
  %arrayidx243 = getelementptr inbounds [3 x double]* %180, i32 0, i64 0
  %181 = load double* %arrayidx243, align 8
  %182 = load [3 x double]** %vp, align 8
  %arrayidx244 = getelementptr inbounds [3 x double]* %182, i32 0, i64 0
  %183 = load double* %arrayidx244, align 8
  %sub245 = fsub double %181, %183
  %arrayidx246 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 0
  store double %sub245, double* %arrayidx246, align 8
  %184 = load [3 x double]** %vptmp, align 8
  %arrayidx247 = getelementptr inbounds [3 x double]* %184, i32 0, i64 1
  %185 = load double* %arrayidx247, align 8
  %186 = load [3 x double]** %vp, align 8
  %arrayidx248 = getelementptr inbounds [3 x double]* %186, i32 0, i64 1
  %187 = load double* %arrayidx248, align 8
  %sub249 = fsub double %185, %187
  %arrayidx250 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 1
  store double %sub249, double* %arrayidx250, align 8
  %188 = load [3 x double]** %vptmp, align 8
  %arrayidx251 = getelementptr inbounds [3 x double]* %188, i32 0, i64 2
  %189 = load double* %arrayidx251, align 8
  %190 = load [3 x double]** %vp, align 8
  %arrayidx252 = getelementptr inbounds [3 x double]* %190, i32 0, i64 2
  %191 = load double* %arrayidx252, align 8
  %sub253 = fsub double %189, %191
  %arrayidx254 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 2
  store double %sub253, double* %arrayidx254, align 8
  %arrayidx255 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 1
  %192 = load double* %arrayidx255, align 8
  %arrayidx256 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 2
  %193 = load double* %arrayidx256, align 8
  %mul257 = fmul double %192, %193
  %arrayidx258 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 2
  %194 = load double* %arrayidx258, align 8
  %arrayidx259 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 1
  %195 = load double* %arrayidx259, align 8
  %mul260 = fmul double %194, %195
  %sub261 = fsub double %mul257, %mul260
  %arrayidx262 = getelementptr inbounds [3 x double]* %cross, i32 0, i64 0
  store double %sub261, double* %arrayidx262, align 8
  %arrayidx263 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 2
  %196 = load double* %arrayidx263, align 8
  %arrayidx264 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 0
  %197 = load double* %arrayidx264, align 8
  %mul265 = fmul double %196, %197
  %arrayidx266 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 0
  %198 = load double* %arrayidx266, align 8
  %arrayidx267 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 2
  %199 = load double* %arrayidx267, align 8
  %mul268 = fmul double %198, %199
  %sub269 = fsub double %mul265, %mul268
  %arrayidx270 = getelementptr inbounds [3 x double]* %cross, i32 0, i64 1
  store double %sub269, double* %arrayidx270, align 8
  %arrayidx271 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 0
  %200 = load double* %arrayidx271, align 8
  %arrayidx272 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 1
  %201 = load double* %arrayidx272, align 8
  %mul273 = fmul double %200, %201
  %arrayidx274 = getelementptr inbounds [3 x double]* %tmppnt, i32 0, i64 1
  %202 = load double* %arrayidx274, align 8
  %arrayidx275 = getelementptr inbounds [3 x double]* %tmppnt2, i32 0, i64 0
  %203 = load double* %arrayidx275, align 8
  %mul276 = fmul double %202, %203
  %sub277 = fsub double %mul273, %mul276
  %arrayidx278 = getelementptr inbounds [3 x double]* %cross, i32 0, i64 2
  store double %sub277, double* %arrayidx278, align 8
  %arrayidx279 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 0
  %204 = load double* %arrayidx279, align 8
  %arrayidx280 = getelementptr inbounds [3 x double]* %cross, i32 0, i64 0
  %205 = load double* %arrayidx280, align 8
  %add281 = fadd double %204, %205
  %arrayidx282 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 0
  store double %add281, double* %arrayidx282, align 8
  %arrayidx283 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 1
  %206 = load double* %arrayidx283, align 8
  %arrayidx284 = getelementptr inbounds [3 x double]* %cross, i32 0, i64 1
  %207 = load double* %arrayidx284, align 8
  %add285 = fadd double %206, %207
  %arrayidx286 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 1
  store double %add285, double* %arrayidx286, align 8
  %arrayidx287 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 2
  %208 = load double* %arrayidx287, align 8
  %arrayidx288 = getelementptr inbounds [3 x double]* %cross, i32 0, i64 2
  %209 = load double* %arrayidx288, align 8
  %add289 = fadd double %208, %209
  %arrayidx290 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 2
  store double %add289, double* %arrayidx290, align 8
  %arrayidx291 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 0
  %210 = load double* %arrayidx291, align 8
  %arrayidx292 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 0
  %211 = load double* %arrayidx292, align 8
  %mul293 = fmul double %210, %211
  %arrayidx294 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 1
  %212 = load double* %arrayidx294, align 8
  %arrayidx295 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 1
  %213 = load double* %arrayidx295, align 8
  %mul296 = fmul double %212, %213
  %add297 = fadd double %mul293, %mul296
  %arrayidx298 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 2
  %214 = load double* %arrayidx298, align 8
  %arrayidx299 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 2
  %215 = load double* %arrayidx299, align 8
  %mul300 = fmul double %214, %215
  %add301 = fadd double %add297, %mul300
  %call302 = call double @sqrt(double %add301)
  %div = fdiv double 1.000000e+00, %call302
  %arrayidx303 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 0
  %216 = load double* %arrayidx303, align 8
  %mul304 = fmul double %div, %216
  %217 = load %struct.poly** %pp, align 8
  %norm305 = getelementptr inbounds %struct.poly* %217, i32 0, i32 1
  %arrayidx306 = getelementptr inbounds [3 x double]* %norm305, i32 0, i64 0
  store double %mul304, double* %arrayidx306, align 8
  %arrayidx307 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 0
  %218 = load double* %arrayidx307, align 8
  %arrayidx308 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 0
  %219 = load double* %arrayidx308, align 8
  %mul309 = fmul double %218, %219
  %arrayidx310 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 1
  %220 = load double* %arrayidx310, align 8
  %arrayidx311 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 1
  %221 = load double* %arrayidx311, align 8
  %mul312 = fmul double %220, %221
  %add313 = fadd double %mul309, %mul312
  %arrayidx314 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 2
  %222 = load double* %arrayidx314, align 8
  %arrayidx315 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 2
  %223 = load double* %arrayidx315, align 8
  %mul316 = fmul double %222, %223
  %add317 = fadd double %add313, %mul316
  %call318 = call double @sqrt(double %add317)
  %div319 = fdiv double 1.000000e+00, %call318
  %arrayidx320 = getelementptr inbounds [3 x double]* %pnorm, i32 0, i64 1
  %224 = load double* %arrayidx320, align 8
  %mul321 = fmul double %div319, %224
  %225 = load %struct.poly** %pp, align 8
  %norm322 = getelementptr inbounds %struct.poly* %225, i32 0, i32 1
  %arrayidx323 = getelementptr inbounds [3 x double]* %norm322, i32 0, i64 1
  store double %mul321, double* %arrayidx323, align 8
  br label %if.end.341

if.end.341:                                       ; preds = %for.end.165, %for.end.86
  %226 = load %struct.poly** %pp, align 8
  %227 = bitcast %struct.poly* %226 to i8*
  %228 = load %struct.element** %pe, align 8
  %data = getelementptr inbounds %struct.element* %228, i32 0, i32 3
  store i8* %227, i8** %data, align 8
  %229 = load %struct.object** %po.addr, align 8
  %230 = load %struct.element** %pe, align 8
  %parent = getelementptr inbounds %struct.element* %230, i32 0, i32 2
  store %struct.object* %229, %struct.object** %parent, align 8
  %231 = load %struct.element** %pe, align 8
  %232 = load %struct.poly** %pp, align 8
  call void @PolyElementBoundBox(%struct.element* %231, %struct.poly* %232)
  %233 = load %struct.poly** %pp, align 8
  %incdec.ptr360 = getelementptr inbounds %struct.poly* %233, i32 1
  store %struct.poly* %incdec.ptr360, %struct.poly** %pp, align 8
  %234 = load %struct.element** %pe, align 8
  %incdec.ptr361 = getelementptr inbounds %struct.element* %234, i32 1
  store %struct.element* %incdec.ptr361, %struct.element** %pe, align 8
  br label %for.inc.362

for.inc.362:                                      ; preds = %if.end.341
  %235 = load i64* %i, align 8
  %inc363 = add nsw i64 %235, 1
  store i64 %inc363, i64* %i, align 8
  br label %for.cond.32

for.end.364:                                      ; preds = %for.cond.32
  ret void

UnifiedUnreachableBlock:                          ; preds = %if.then.81, %if.then.61, %if.then.47, %if.then.41, %if.then.26, %if.then.10, %if.then
  unreachable
}

; Function Attrs: nounwind uwtable
define internal void @CopyRayMsg(%struct.ray* %rdst, %struct.ray* %rsrc) {
entry:
  %rdst.addr = alloca %struct.ray*, align 8
  %rsrc.addr = alloca %struct.ray*, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @InitRayTreeStack(i64 %TreeDepth, i64 %pid) {
entry:
  %TreeDepth.addr = alloca i64, align 8
  %pid.addr = alloca i64, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal i32 @powint(i32 %i, i32 %j) {
entry:
  %i.addr = alloca i32, align 4
  %j.addr = alloca i32, align 4
  %k = alloca i32, align 4
  %temp = alloca i32, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br label %for.end

for.body:                                         ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 undef
}

; Function Attrs: nounwind uwtable
define internal void @PushRayTreeStack(%struct.ray* %rmsg, i64 %pid) {
entry:
  %rmsg.addr = alloca %struct.ray*, align 8
  %pid.addr = alloca i64, align 8
  br i1 undef, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  unreachable

if.end:                                           ; preds = %entry
  ret void
}

; Function Attrs: nounwind uwtable
define internal i64 @PopRayTreeStack(%struct.ray* %rmsg, i64 %pid) {
entry:
  %retval = alloca i64, align 8
  %rmsg.addr = alloca %struct.ray*, align 8
  %pid.addr = alloca i64, align 8
  br label %return

if.then:                                          ; No predecessors!
  br label %return

if.end:                                           ; No predecessors!
  br label %return

return:                                           ; preds = %entry, %if.end, %if.then
  ret i64 undef
}

; Function Attrs: nounwind uwtable
define internal void @SpecularDirection(double* %R, double* %N, double* %I) {
entry:
  %R.addr = alloca double*, align 8
  %N.addr = alloca double*, align 8
  %I.addr = alloca double*, align 8
  %I_dot_N = alloca double, align 8
  %N2 = alloca [4 x double], align 16
  %vprime = alloca [4 x double], align 16
  br label %cond.end

cond.true:                                        ; No predecessors!
  br label %cond.end

cond.false:                                       ; No predecessors!
  br label %cond.end

cond.end:                                         ; preds = %entry, %cond.false, %cond.true
  ret void
}

; Function Attrs: nounwind uwtable
define internal i64 @TransmissionDirection(double* %T, double* %N, double* %I, double %kn) {
entry:
  %retval = alloca i64, align 8
  %T.addr = alloca double*, align 8
  %N.addr = alloca double*, align 8
  %I.addr = alloca double*, align 8
  %kn.addr = alloca double, align 8
  %vprime = alloca [4 x double], align 16
  %vplusn = alloca [4 x double], align 16
  %I_dot_N = alloca double, align 8
  %kf = alloca double, align 8
  %vprime_sq = alloca double, align 8
  %vplusn_sq = alloca double, align 8
  br label %cond.end

cond.true:                                        ; No predecessors!
  br label %cond.end

cond.false:                                       ; No predecessors!
  br label %cond.end

cond.end:                                         ; preds = %entry, %cond.false, %cond.true
  br label %return

if.then:                                          ; No predecessors!
  br label %if.end

if.else:                                          ; No predecessors!
  br label %return

if.end:                                           ; preds = %if.then
  br label %return

return:                                           ; preds = %cond.end, %if.end, %if.else
  ret i64 undef
}

; Function Attrs: nounwind uwtable
define internal void @Shade(double* %iP, double* %N, %struct.ray* %ray, %struct.irecord* %hit, i64 %pid) {
entry:
  %iP.addr = alloca double*, align 8
  %N.addr = alloca double*, align 8
  %ray.addr = alloca %struct.ray*, align 8
  %hit.addr = alloca %struct.irecord*, align 8
  %pid.addr = alloca i64, align 8
  %Lvec = alloca [3 x double], align 16
  %Hvec = alloca [3 x double], align 16
  %Evec = alloca [3 x double], align 16
  %shad_ray = alloca %struct.ray, align 8
  %secondary_ray = alloca %struct.ray, align 8
  %surfcol = alloca [3 x double], align 16
  %col = alloca [3 x double], align 16
  %NdotL = alloca double, align 8
  %Diff = alloca double, align 8
  %NdotH = alloca double, align 8
  %spec = alloca double, align 8
  %po = alloca %struct.object*, align 8
  %s = alloca %struct.surf*, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %lightlen = alloca double, align 8
  %shadtrans = alloca double, align 8
  %lptr = alloca %struct.light*, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br label %for.end

for.body:                                         ; No predecessors!
  br label %if.end.164

if.then:                                          ; No predecessors!
  br label %if.end

land.lhs.true:                                    ; No predecessors!
  br label %if.end

if.then.83:                                       ; No predecessors!
  br label %sw.epilog

sw.bb:                                            ; No predecessors!
  br label %sw.epilog

sw.bb.86:                                         ; No predecessors!
  br label %sw.epilog

sw.epilog:                                        ; preds = %if.then.83, %sw.bb.86, %sw.bb
  br label %if.end

if.else:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %land.lhs.true, %if.then, %if.else, %sw.epilog
  br label %if.end.163

if.then.90:                                       ; No predecessors!
  br label %if.end.162

if.then.116:                                      ; No predecessors!
  br label %if.end.161

if.then.142:                                      ; No predecessors!
  br label %if.end.161

if.end.161:                                       ; preds = %if.then.116, %if.then.142
  br label %if.end.162

if.end.162:                                       ; preds = %if.then.90, %if.end.161
  br label %if.end.163

if.end.163:                                       ; preds = %if.end, %if.end.162
  br label %if.end.164

if.end.164:                                       ; preds = %for.body, %if.end.163
  br label %for.inc

for.inc:                                          ; preds = %if.end.164
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %if.end.259

if.then.183:                                      ; No predecessors!
  br label %if.end.223

if.then.204:                                      ; No predecessors!
  br label %if.end.223

if.end.223:                                       ; preds = %if.then.183, %if.then.204
  br label %if.end.258

if.then.234:                                      ; No predecessors!
  br label %if.end.257

if.then.242:                                      ; No predecessors!
  br label %if.end.257

if.end.257:                                       ; preds = %if.then.234, %if.then.242
  br label %if.end.258

if.end.258:                                       ; preds = %if.end.223, %if.end.257
  br label %if.end.259

if.end.259:                                       ; preds = %for.end, %if.end.258
  ret void
}

; Function Attrs: nounwind
declare double @pow(double, double)

; Function Attrs: nounwind uwtable
define internal i8* @SphName() {
entry:
  ret i8* getelementptr inbounds ([7 x i8]* @.str.404, i32 0, i32 0)
}

; Function Attrs: nounwind uwtable
define internal void @SphPrint(%struct.object* %po) {
entry:
  %po.addr = alloca %struct.object*, align 8
  %i = alloca i64, align 8
  %ps = alloca %struct.sphere*, align 8
  %pe = alloca %struct.element*, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br label %for.end

for.body:                                         ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @SphElementBoundBox(%struct.element* %pe, %struct.sphere* %ps) {
entry:
  %pe.addr = alloca %struct.element*, align 8
  %ps.addr = alloca %struct.sphere*, align 8
  %pbb = alloca %struct.bbox*, align 8
  store %struct.element* %pe, %struct.element** %pe.addr, align 8
  store %struct.sphere* %ps, %struct.sphere** %ps.addr, align 8
  %0 = load %struct.element** %pe.addr, align 8
  %bv = getelementptr inbounds %struct.element* %0, i32 0, i32 1
  store %struct.bbox* %bv, %struct.bbox** %pbb, align 8
  %1 = load %struct.sphere** %ps.addr, align 8
  %center = getelementptr inbounds %struct.sphere* %1, i32 0, i32 0
  %arrayidx = getelementptr inbounds [4 x double]* %center, i32 0, i64 0
  %2 = load double* %arrayidx, align 8
  %3 = load %struct.sphere** %ps.addr, align 8
  %rad = getelementptr inbounds %struct.sphere* %3, i32 0, i32 1
  %4 = load double* %rad, align 8
  %sub = fsub double %2, %4
  %5 = load %struct.bbox** %pbb, align 8
  %dnear = getelementptr inbounds %struct.bbox* %5, i32 0, i32 0
  %arrayidx1 = getelementptr inbounds [3 x double]* %dnear, i32 0, i64 0
  store double %sub, double* %arrayidx1, align 8
  %6 = load %struct.sphere** %ps.addr, align 8
  %center2 = getelementptr inbounds %struct.sphere* %6, i32 0, i32 0
  %arrayidx3 = getelementptr inbounds [4 x double]* %center2, i32 0, i64 1
  %7 = load double* %arrayidx3, align 8
  %8 = load %struct.sphere** %ps.addr, align 8
  %rad4 = getelementptr inbounds %struct.sphere* %8, i32 0, i32 1
  %9 = load double* %rad4, align 8
  %sub5 = fsub double %7, %9
  %10 = load %struct.bbox** %pbb, align 8
  %dnear6 = getelementptr inbounds %struct.bbox* %10, i32 0, i32 0
  %arrayidx7 = getelementptr inbounds [3 x double]* %dnear6, i32 0, i64 1
  store double %sub5, double* %arrayidx7, align 8
  %11 = load %struct.sphere** %ps.addr, align 8
  %center8 = getelementptr inbounds %struct.sphere* %11, i32 0, i32 0
  %arrayidx9 = getelementptr inbounds [4 x double]* %center8, i32 0, i64 2
  %12 = load double* %arrayidx9, align 8
  %13 = load %struct.sphere** %ps.addr, align 8
  %rad10 = getelementptr inbounds %struct.sphere* %13, i32 0, i32 1
  %14 = load double* %rad10, align 8
  %sub11 = fsub double %12, %14
  %15 = load %struct.bbox** %pbb, align 8
  %dnear12 = getelementptr inbounds %struct.bbox* %15, i32 0, i32 0
  %arrayidx13 = getelementptr inbounds [3 x double]* %dnear12, i32 0, i64 2
  store double %sub11, double* %arrayidx13, align 8
  %16 = load %struct.sphere** %ps.addr, align 8
  %center14 = getelementptr inbounds %struct.sphere* %16, i32 0, i32 0
  %arrayidx15 = getelementptr inbounds [4 x double]* %center14, i32 0, i64 0
  %17 = load double* %arrayidx15, align 8
  %18 = load %struct.sphere** %ps.addr, align 8
  %rad16 = getelementptr inbounds %struct.sphere* %18, i32 0, i32 1
  %19 = load double* %rad16, align 8
  %add = fadd double %17, %19
  %20 = load %struct.bbox** %pbb, align 8
  %dfar = getelementptr inbounds %struct.bbox* %20, i32 0, i32 1
  %arrayidx17 = getelementptr inbounds [3 x double]* %dfar, i32 0, i64 0
  store double %add, double* %arrayidx17, align 8
  %21 = load %struct.sphere** %ps.addr, align 8
  %center18 = getelementptr inbounds %struct.sphere* %21, i32 0, i32 0
  %arrayidx19 = getelementptr inbounds [4 x double]* %center18, i32 0, i64 1
  %22 = load double* %arrayidx19, align 8
  %23 = load %struct.sphere** %ps.addr, align 8
  %rad20 = getelementptr inbounds %struct.sphere* %23, i32 0, i32 1
  %24 = load double* %rad20, align 8
  %add21 = fadd double %22, %24
  %25 = load %struct.bbox** %pbb, align 8
  %dfar22 = getelementptr inbounds %struct.bbox* %25, i32 0, i32 1
  %arrayidx23 = getelementptr inbounds [3 x double]* %dfar22, i32 0, i64 1
  store double %add21, double* %arrayidx23, align 8
  %26 = load %struct.sphere** %ps.addr, align 8
  %center24 = getelementptr inbounds %struct.sphere* %26, i32 0, i32 0
  %arrayidx25 = getelementptr inbounds [4 x double]* %center24, i32 0, i64 2
  %27 = load double* %arrayidx25, align 8
  %28 = load %struct.sphere** %ps.addr, align 8
  %rad26 = getelementptr inbounds %struct.sphere* %28, i32 0, i32 1
  %29 = load double* %rad26, align 8
  %add27 = fadd double %27, %29
  %30 = load %struct.bbox** %pbb, align 8
  %dfar28 = getelementptr inbounds %struct.bbox* %30, i32 0, i32 1
  %arrayidx29 = getelementptr inbounds [3 x double]* %dfar28, i32 0, i64 2
  store double %add27, double* %arrayidx29, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @SphBoundBox(%struct.object* %po) {
entry:
  %po.addr = alloca %struct.object*, align 8
  %i = alloca i64, align 8
  %ps = alloca %struct.sphere*, align 8
  %pe = alloca %struct.element*, align 8
  %pbb = alloca %struct.bbox*, align 8
  %minx = alloca double, align 8
  %maxx = alloca double, align 8
  %miny = alloca double, align 8
  %maxy = alloca double, align 8
  %minz = alloca double, align 8
  %maxz = alloca double, align 8
  store %struct.object* %po, %struct.object** %po.addr, align 8
  %0 = load %struct.object** %po.addr, align 8
  %pelem = getelementptr inbounds %struct.object* %0, i32 0, i32 3
  %1 = load %struct.element** %pelem, align 8
  store %struct.element* %1, %struct.element** %pe, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %2 = load i64* %i, align 8
  %3 = load %struct.object** %po.addr, align 8
  %numelements = getelementptr inbounds %struct.object* %3, i32 0, i32 4
  %4 = load i64* %numelements, align 8
  %cmp = icmp slt i64 %2, %4
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %5 = load %struct.element** %pe, align 8
  %data = getelementptr inbounds %struct.element* %5, i32 0, i32 3
  %6 = load i8** %data, align 8
  %7 = bitcast i8* %6 to %struct.sphere*
  store %struct.sphere* %7, %struct.sphere** %ps, align 8
  %8 = load %struct.element** %pe, align 8
  %9 = load %struct.sphere** %ps, align 8
  call void @SphElementBoundBox(%struct.element* %8, %struct.sphere* %9)
  br label %cond.end

cond.true:                                        ; No predecessors!
  br label %cond.end

cond.false:                                       ; No predecessors!
  br label %cond.end

cond.end:                                         ; preds = %for.body, %cond.false, %cond.true
  br label %cond.end.15

cond.true.10:                                     ; No predecessors!
  br label %cond.end.15

cond.false.11:                                    ; No predecessors!
  br label %cond.end.15

cond.end.15:                                      ; preds = %cond.end, %cond.false.11, %cond.true.10
  br label %cond.end.26

cond.true.21:                                     ; No predecessors!
  br label %cond.end.26

cond.false.22:                                    ; No predecessors!
  br label %cond.end.26

cond.end.26:                                      ; preds = %cond.end.15, %cond.false.22, %cond.true.21
  br label %cond.end.36

cond.true.31:                                     ; No predecessors!
  br label %cond.end.36

cond.false.32:                                    ; No predecessors!
  br label %cond.end.36

cond.end.36:                                      ; preds = %cond.end.26, %cond.false.32, %cond.true.31
  br label %cond.end.47

cond.true.42:                                     ; No predecessors!
  br label %cond.end.47

cond.false.43:                                    ; No predecessors!
  br label %cond.end.47

cond.end.47:                                      ; preds = %cond.end.36, %cond.false.43, %cond.true.42
  br label %cond.end.58

cond.true.53:                                     ; No predecessors!
  br label %cond.end.58

cond.false.54:                                    ; No predecessors!
  br label %cond.end.58

cond.end.58:                                      ; preds = %cond.end.47, %cond.false.54, %cond.true.53
  %10 = load %struct.element** %pe, align 8
  %incdec.ptr = getelementptr inbounds %struct.element* %10, i32 1
  store %struct.element* %incdec.ptr, %struct.element** %pe, align 8
  br label %for.inc

for.inc:                                          ; preds = %cond.end.58
  %11 = load i64* %i, align 8
  %inc = add nsw i64 %11, 1
  store i64 %inc, i64* %i, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @SphNormal(%struct.irecord* %hit, double* %Pi, double* %Ni) {
entry:
  %hit.addr = alloca %struct.irecord*, align 8
  %Pi.addr = alloca double*, align 8
  %Ni.addr = alloca double*, align 8
  %pe = alloca %struct.element*, align 8
  %ps = alloca %struct.sphere*, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @SphDataNormalize(%struct.object* %po, [4 x double]* %normMat) {
entry:
  %po.addr = alloca %struct.object*, align 8
  %normMat.addr = alloca [4 x double]*, align 8
  %i = alloca i64, align 8
  %ps = alloca %struct.sphere*, align 8
  %pe = alloca %struct.element*, align 8
  %surf_point = alloca [4 x double], align 16
  %center_point = alloca [4 x double], align 16
  %rad_vector = alloca [4 x double], align 16
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br label %for.end

for.body:                                         ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal i64 @SphPeIntersect(%struct.ray* %pr, %struct.element* %pe, %struct.irecord* %hit) {
entry:
  %retval = alloca i64, align 8
  %pr.addr = alloca %struct.ray*, align 8
  %pe.addr = alloca %struct.element*, align 8
  %hit.addr = alloca %struct.irecord*, align 8
  %nhits = alloca i64, align 8
  %b = alloca double, align 8
  %disc = alloca double, align 8
  %t1 = alloca double, align 8
  %t2 = alloca double, align 8
  %vsq = alloca double, align 8
  %ps = alloca %struct.sphere*, align 8
  %V = alloca [4 x double], align 16
  %sphhit = alloca %struct.irecord*, align 8
  br label %return

land.lhs.true:                                    ; No predecessors!
  br label %return

if.then:                                          ; No predecessors!
  br label %return

if.end:                                           ; No predecessors!
  br label %return

if.then.43:                                       ; No predecessors!
  br label %return

if.end.44:                                        ; No predecessors!
  br label %return

if.then.48:                                       ; No predecessors!
  br label %return

if.end.49:                                        ; No predecessors!
  br label %if.end.52

if.then.51:                                       ; No predecessors!
  br label %if.end.52

if.end.52:                                        ; preds = %if.end.49, %if.then.51
  br label %return

return:                                           ; preds = %if.end.44, %if.end, %land.lhs.true, %entry, %if.end.52, %if.then.48, %if.then.43, %if.then
  ret i64 undef
}

; Function Attrs: nounwind uwtable
define internal i64 @SphIntersect(%struct.ray* %pr, %struct.object* %po, %struct.irecord* %hit) {
entry:
  %pr.addr = alloca %struct.ray*, align 8
  %po.addr = alloca %struct.object*, align 8
  %hit.addr = alloca %struct.irecord*, align 8
  %i = alloca i64, align 8
  %nhits = alloca i64, align 8
  %pe = alloca %struct.element*, align 8
  %newhit = alloca [2 x %struct.irecord], align 16
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br label %for.end

for.body:                                         ; No predecessors!
  br label %if.end.15

if.then:                                          ; No predecessors!
  br label %if.end

if.then.6:                                        ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %if.then, %if.then.6
  br label %if.end.15

if.end.15:                                        ; preds = %for.body, %if.end
  br label %for.inc

for.inc:                                          ; preds = %if.end.15
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i64 undef
}

; Function Attrs: nounwind uwtable
define internal void @SphTransform(%struct.object* %po, [4 x double]* %xtrans, [4 x double]* %xinvT) {
entry:
  %po.addr = alloca %struct.object*, align 8
  %xtrans.addr = alloca [4 x double]*, align 8
  %xinvT.addr = alloca [4 x double]*, align 8
  %i = alloca i64, align 8
  %numelems = alloca i64, align 8
  %new_rad = alloca double, align 8
  %ps = alloca %struct.sphere*, align 8
  %pe = alloca %struct.element*, align 8
  %surf_point = alloca [4 x double], align 16
  %center_point = alloca [4 x double], align 16
  %rad_vector = alloca [4 x double], align 16
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br label %for.end

for.body:                                         ; No predecessors!
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %for.body, %if.then
  br label %for.inc

for.inc:                                          ; preds = %if.end
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @SphRead(%struct.object* %po, %struct._IO_FILE* %pf) {
entry:
  %po.addr = alloca %struct.object*, align 8
  %pf.addr = alloca %struct._IO_FILE*, align 8
  %i = alloca i64, align 8
  %instat = alloca i64, align 8
  %ps = alloca %struct.sphere*, align 8
  %pe = alloca %struct.element*, align 8
  store %struct.object* %po, %struct.object** %po.addr, align 8
  store %struct._IO_FILE* %pf, %struct._IO_FILE** %pf.addr, align 8
  %0 = load %struct.object** %po.addr, align 8
  %pelem = getelementptr inbounds %struct.object* %0, i32 0, i32 3
  %1 = load %struct.element** %pelem, align 8
  store %struct.element* %1, %struct.element** %pe, align 8
  %2 = load %struct.object** %po.addr, align 8
  %numelements = getelementptr inbounds %struct.object* %2, i32 0, i32 4
  %3 = load i64* %numelements, align 8
  %mul = mul i64 48, %3
  %call = call i8* @GlobalMalloc(i64 %mul, i8* getelementptr inbounds ([6 x i8]* @.str.4.408, i32 0, i32 0))
  %4 = bitcast i8* %call to %struct.sphere*
  store %struct.sphere* %4, %struct.sphere** %ps, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %5 = load i64* %i, align 8
  %6 = load %struct.object** %po.addr, align 8
  %numelements1 = getelementptr inbounds %struct.object* %6, i32 0, i32 4
  %7 = load i64* %numelements1, align 8
  %cmp = icmp slt i64 %5, %7
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %8 = load %struct._IO_FILE** %pf.addr, align 8
  %9 = load %struct.sphere** %ps, align 8
  %center = getelementptr inbounds %struct.sphere* %9, i32 0, i32 0
  %arrayidx = getelementptr inbounds [4 x double]* %center, i32 0, i64 0
  %10 = load %struct.sphere** %ps, align 8
  %center2 = getelementptr inbounds %struct.sphere* %10, i32 0, i32 0
  %arrayidx3 = getelementptr inbounds [4 x double]* %center2, i32 0, i64 1
  %11 = load %struct.sphere** %ps, align 8
  %center4 = getelementptr inbounds %struct.sphere* %11, i32 0, i32 0
  %arrayidx5 = getelementptr inbounds [4 x double]* %center4, i32 0, i64 2
  %12 = load %struct.sphere** %ps, align 8
  %rad = getelementptr inbounds %struct.sphere* %12, i32 0, i32 1
  %call6 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %8, i8* getelementptr inbounds ([16 x i8]* @.str.5.409, i32 0, i32 0), double* %arrayidx, double* %arrayidx3, double* %arrayidx5, double* %rad)
  %conv = sext i32 %call6 to i64
  store i64 %conv, i64* %instat, align 8
  %13 = load i64* %instat, align 8
  %cmp7 = icmp ne i64 %13, 4
  br i1 %cmp7, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  unreachable

if.end:                                           ; preds = %for.body
  %14 = load %struct.sphere** %ps, align 8
  %15 = bitcast %struct.sphere* %14 to i8*
  %16 = load %struct.element** %pe, align 8
  %data = getelementptr inbounds %struct.element* %16, i32 0, i32 3
  store i8* %15, i8** %data, align 8
  %17 = load %struct.element** %pe, align 8
  %18 = load %struct.sphere** %ps, align 8
  call void @SphElementBoundBox(%struct.element* %17, %struct.sphere* %18)
  %19 = load %struct.sphere** %ps, align 8
  %incdec.ptr = getelementptr inbounds %struct.sphere* %19, i32 1
  store %struct.sphere* %incdec.ptr, %struct.sphere** %ps, align 8
  %20 = load %struct.element** %pe, align 8
  %incdec.ptr15 = getelementptr inbounds %struct.element* %20, i32 1
  store %struct.element* %incdec.ptr15, %struct.element** %pe, align 8
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %21 = load i64* %i, align 8
  %inc = add nsw i64 %21, 1
  store i64 %inc, i64* %i, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal double @frand() {
entry:
  %r = alloca double, align 8
  ret double undef
}

; Function Attrs: nounwind uwtable
define internal i64 @GetRayJobFromBundle(%struct.rayjob* %job, i64* %x, i64* %y) {
entry:
  %retval = alloca i64, align 8
  %job.addr = alloca %struct.rayjob*, align 8
  %x.addr = alloca i64*, align 8
  %y.addr = alloca i64*, align 8
  br label %return

if.then:                                          ; No predecessors!
  br label %return

if.end:                                           ; No predecessors!
  br label %if.end.13

if.then.8:                                        ; No predecessors!
  br label %if.end.13

if.end.13:                                        ; preds = %if.end, %if.then.8
  br label %return

return:                                           ; preds = %entry, %if.end.13, %if.then
  ret i64 undef
}

; Function Attrs: nounwind uwtable
define internal void @ConvertPrimRayJobToRayMsg(%struct.ray* %ray, double %x, double %y) {
entry:
  %ray.addr = alloca %struct.ray*, align 8
  %x.addr = alloca double, align 8
  %y.addr = alloca double, align 8
  %dir = alloca [4 x double], align 16
  %origin = alloca [4 x double], align 16
  br label %if.end

if.then:                                          ; No predecessors!
  br label %if.end

if.else:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %entry, %if.else, %if.then
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @RayTrace(i64 %pid) {
entry:
  %pid.addr = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %x = alloca i64, align 8
  %y = alloca i64, align 8
  %xx = alloca double, align 8
  %yy = alloca double, align 8
  %N = alloca [3 x double], align 16
  %Ipoint = alloca [3 x double], align 16
  %c = alloca [3 x double], align 16
  %ray = alloca %struct.ray*, align 8
  %rmsg = alloca %struct.ray, align 8
  %job = alloca %struct.rayjob, align 8
  %po = alloca %struct.object*, align 8
  %hit = alloca i64, align 8
  %hitrecord = alloca %struct.irecord, align 8
  br label %while.cond

while.cond:                                       ; preds = %while.end.91, %entry
  br label %while.end.92

while.body:                                       ; No predecessors!
  br label %while.cond.1

while.cond.1:                                     ; preds = %while.end, %while.body
  br label %while.end.91

while.body.3:                                     ; No predecessors!
  br label %if.end

if.then:                                          ; No predecessors!
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.then
  br label %for.end

for.body:                                         ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %if.end

if.else:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %while.body.3, %if.else, %for.end
  br label %while.cond.11

while.cond.11:                                    ; preds = %if.end.90, %if.end
  br label %while.end

while.body.15:                                    ; No predecessors!
  br label %sw.epilog

sw.bb:                                            ; No predecessors!
  br label %sw.epilog

sw.bb.17:                                         ; No predecessors!
  br label %sw.epilog

sw.epilog:                                        ; preds = %while.body.15, %sw.bb.17, %sw.bb
  br label %if.end.90

if.then.20:                                       ; No predecessors!
  br label %if.end.66

if.then.57:                                       ; No predecessors!
  br label %if.end.66

if.end.66:                                        ; preds = %if.then.20, %if.then.57
  br label %if.end.90

if.else.69:                                       ; No predecessors!
  br label %if.end.90

if.end.90:                                        ; preds = %sw.epilog, %if.else.69, %if.end.66
  br label %while.cond.11

while.end:                                        ; preds = %while.cond.11
  br label %while.cond.1

while.end.91:                                     ; preds = %while.cond.1
  br label %while.cond

while.end.92:                                     ; preds = %while.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal i8* @TriName() {
entry:
  ret i8* getelementptr inbounds ([5 x i8]* @.str.429, i32 0, i32 0)
}

; Function Attrs: nounwind uwtable
define internal void @TriPrint(%struct.object* %po) {
entry:
  %po.addr = alloca %struct.object*, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %vindex = alloca i64*, align 8
  %vlist = alloca [3 x double]*, align 8
  %vptr = alloca [3 x double]*, align 8
  %pt = alloca %struct.tri*, align 8
  %pe = alloca %struct.element*, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc.17, %entry
  br label %for.end.19

for.body:                                         ; No predecessors!
  br label %for.cond.9

for.cond.9:                                       ; preds = %for.inc, %for.body
  br label %for.end

for.body.11:                                      ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body.11
  br label %for.cond.9

for.end:                                          ; preds = %for.cond.9
  br label %for.inc.17

for.inc.17:                                       ; preds = %for.end
  br label %for.cond

for.end.19:                                       ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @TriElementBoundBox(%struct.element* %pe, %struct.tri* %pt) {
entry:
  %pe.addr = alloca %struct.element*, align 8
  %pt.addr = alloca %struct.tri*, align 8
  %i = alloca i64, align 8
  %vindex = alloca i64*, align 8
  %pbb = alloca %struct.bbox*, align 8
  %vlist = alloca [3 x double]*, align 8
  %vptr = alloca [3 x double]*, align 8
  %minx = alloca double, align 8
  %maxx = alloca double, align 8
  %miny = alloca double, align 8
  %maxy = alloca double, align 8
  %minz = alloca double, align 8
  %maxz = alloca double, align 8
  store %struct.element* %pe, %struct.element** %pe.addr, align 8
  store %struct.tri* %pt, %struct.tri** %pt.addr, align 8
  %0 = load %struct.element** %pe.addr, align 8
  %bv = getelementptr inbounds %struct.element* %0, i32 0, i32 1
  store %struct.bbox* %bv, %struct.bbox** %pbb, align 8
  store double 1.000000e+32, double* %minz, align 8
  store double 1.000000e+32, double* %miny, align 8
  store double 1.000000e+32, double* %minx, align 8
  store double -1.000000e+32, double* %maxz, align 8
  store double -1.000000e+32, double* %maxx, align 8
  %1 = load %struct.tri** %pt.addr, align 8
  %vptr1 = getelementptr inbounds %struct.tri* %1, i32 0, i32 2
  %2 = load [3 x double]** %vptr1, align 8
  store [3 x double]* %2, [3 x double]** %vlist, align 8
  %3 = load %struct.tri** %pt.addr, align 8
  %vindex2 = getelementptr inbounds %struct.tri* %3, i32 0, i32 4
  %arraydecay = getelementptr inbounds [3 x i64]* %vindex2, i32 0, i32 0
  store i64* %arraydecay, i64** %vindex, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %4 = load i64* %i, align 8
  %cmp = icmp slt i64 %4, 3
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %5 = load [3 x double]** %vlist, align 8
  %6 = load i64** %vindex, align 8
  %7 = load i64* %6, align 8
  %add.ptr = getelementptr inbounds [3 x double]* %5, i64 %7
  store [3 x double]* %add.ptr, [3 x double]** %vptr, align 8
  %8 = load double* %minx, align 8
  %9 = load [3 x double]** %vptr, align 8
  %arrayidx = getelementptr inbounds [3 x double]* %9, i32 0, i64 0
  %10 = load double* %arrayidx, align 8
  %cmp3 = fcmp olt double %8, %10
  br i1 %cmp3, label %cond.true, label %cond.false

cond.true:                                        ; preds = %for.body
  %11 = load double* %minx, align 8
  br label %cond.end

cond.false:                                       ; preds = %for.body
  %12 = load [3 x double]** %vptr, align 8
  %arrayidx4 = getelementptr inbounds [3 x double]* %12, i32 0, i64 0
  %13 = load double* %arrayidx4, align 8
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi double [ %11, %cond.true ], [ %13, %cond.false ]
  store double %cond, double* %minx, align 8
  %14 = load double* %miny, align 8
  %15 = load [3 x double]** %vptr, align 8
  %arrayidx5 = getelementptr inbounds [3 x double]* %15, i32 0, i64 1
  %16 = load double* %arrayidx5, align 8
  %cmp6 = fcmp olt double %14, %16
  br i1 %cmp6, label %cond.true.7, label %cond.false.8

cond.true.7:                                      ; preds = %cond.end
  %17 = load double* %miny, align 8
  br label %cond.end.10

cond.false.8:                                     ; preds = %cond.end
  %18 = load [3 x double]** %vptr, align 8
  %arrayidx9 = getelementptr inbounds [3 x double]* %18, i32 0, i64 1
  %19 = load double* %arrayidx9, align 8
  br label %cond.end.10

cond.end.10:                                      ; preds = %cond.false.8, %cond.true.7
  %cond11 = phi double [ %17, %cond.true.7 ], [ %19, %cond.false.8 ]
  store double %cond11, double* %miny, align 8
  %20 = load double* %minz, align 8
  %21 = load [3 x double]** %vptr, align 8
  %arrayidx12 = getelementptr inbounds [3 x double]* %21, i32 0, i64 2
  %22 = load double* %arrayidx12, align 8
  %cmp13 = fcmp olt double %20, %22
  br i1 %cmp13, label %cond.true.14, label %cond.false.15

cond.true.14:                                     ; preds = %cond.end.10
  %23 = load double* %minz, align 8
  br label %cond.end.17

cond.false.15:                                    ; preds = %cond.end.10
  %24 = load [3 x double]** %vptr, align 8
  %arrayidx16 = getelementptr inbounds [3 x double]* %24, i32 0, i64 2
  %25 = load double* %arrayidx16, align 8
  br label %cond.end.17

cond.end.17:                                      ; preds = %cond.false.15, %cond.true.14
  %cond18 = phi double [ %23, %cond.true.14 ], [ %25, %cond.false.15 ]
  store double %cond18, double* %minz, align 8
  %26 = load double* %maxx, align 8
  %27 = load [3 x double]** %vptr, align 8
  %arrayidx19 = getelementptr inbounds [3 x double]* %27, i32 0, i64 0
  %28 = load double* %arrayidx19, align 8
  %cmp20 = fcmp ogt double %26, %28
  br i1 %cmp20, label %cond.true.21, label %cond.false.22

cond.true.21:                                     ; preds = %cond.end.17
  %29 = load double* %maxx, align 8
  br label %cond.end.24

cond.false.22:                                    ; preds = %cond.end.17
  %30 = load [3 x double]** %vptr, align 8
  %arrayidx23 = getelementptr inbounds [3 x double]* %30, i32 0, i64 0
  %31 = load double* %arrayidx23, align 8
  br label %cond.end.24

cond.end.24:                                      ; preds = %cond.false.22, %cond.true.21
  %cond25 = phi double [ %29, %cond.true.21 ], [ %31, %cond.false.22 ]
  store double %cond25, double* %maxx, align 8
  br label %cond.end.31

cond.true.28:                                     ; No predecessors!
  br label %cond.end.31

cond.false.29:                                    ; No predecessors!
  br label %cond.end.31

cond.end.31:                                      ; preds = %cond.end.24, %cond.false.29, %cond.true.28
  %32 = load double* %maxz, align 8
  %33 = load [3 x double]** %vptr, align 8
  %arrayidx33 = getelementptr inbounds [3 x double]* %33, i32 0, i64 2
  %34 = load double* %arrayidx33, align 8
  %cmp34 = fcmp ogt double %32, %34
  br i1 %cmp34, label %cond.true.35, label %cond.false.36

cond.true.35:                                     ; preds = %cond.end.31
  %35 = load double* %maxz, align 8
  br label %cond.end.38

cond.false.36:                                    ; preds = %cond.end.31
  %36 = load [3 x double]** %vptr, align 8
  %arrayidx37 = getelementptr inbounds [3 x double]* %36, i32 0, i64 2
  %37 = load double* %arrayidx37, align 8
  br label %cond.end.38

cond.end.38:                                      ; preds = %cond.false.36, %cond.true.35
  %cond39 = phi double [ %35, %cond.true.35 ], [ %37, %cond.false.36 ]
  store double %cond39, double* %maxz, align 8
  %38 = load i64** %vindex, align 8
  %incdec.ptr = getelementptr inbounds i64* %38, i32 1
  store i64* %incdec.ptr, i64** %vindex, align 8
  br label %for.inc

for.inc:                                          ; preds = %cond.end.38
  %39 = load i64* %i, align 8
  %inc = add nsw i64 %39, 1
  store i64 %inc, i64* %i, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %40 = load double* %minx, align 8
  %41 = load %struct.bbox** %pbb, align 8
  %dnear = getelementptr inbounds %struct.bbox* %41, i32 0, i32 0
  %arrayidx40 = getelementptr inbounds [3 x double]* %dnear, i32 0, i64 0
  store double %40, double* %arrayidx40, align 8
  %42 = load double* %miny, align 8
  %43 = load %struct.bbox** %pbb, align 8
  %dnear41 = getelementptr inbounds %struct.bbox* %43, i32 0, i32 0
  %arrayidx42 = getelementptr inbounds [3 x double]* %dnear41, i32 0, i64 1
  store double %42, double* %arrayidx42, align 8
  %44 = load double* %minz, align 8
  %45 = load %struct.bbox** %pbb, align 8
  %dnear43 = getelementptr inbounds %struct.bbox* %45, i32 0, i32 0
  %arrayidx44 = getelementptr inbounds [3 x double]* %dnear43, i32 0, i64 2
  store double %44, double* %arrayidx44, align 8
  %46 = load double* %maxx, align 8
  %47 = load %struct.bbox** %pbb, align 8
  %dfar = getelementptr inbounds %struct.bbox* %47, i32 0, i32 1
  %arrayidx45 = getelementptr inbounds [3 x double]* %dfar, i32 0, i64 0
  store double %46, double* %arrayidx45, align 8
  %48 = load double* %maxz, align 8
  %49 = load %struct.bbox** %pbb, align 8
  %dfar48 = getelementptr inbounds %struct.bbox* %49, i32 0, i32 1
  %arrayidx49 = getelementptr inbounds [3 x double]* %dfar48, i32 0, i64 2
  store double %48, double* %arrayidx49, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @TriBoundBox(%struct.object* %po) {
entry:
  %po.addr = alloca %struct.object*, align 8
  %i = alloca i64, align 8
  %pt = alloca %struct.tri*, align 8
  %pe = alloca %struct.element*, align 8
  %pbb = alloca %struct.bbox*, align 8
  %minx = alloca double, align 8
  %maxx = alloca double, align 8
  %miny = alloca double, align 8
  %maxy = alloca double, align 8
  %minz = alloca double, align 8
  %maxz = alloca double, align 8
  store %struct.object* %po, %struct.object** %po.addr, align 8
  %0 = load %struct.object** %po.addr, align 8
  %pelem = getelementptr inbounds %struct.object* %0, i32 0, i32 3
  %1 = load %struct.element** %pelem, align 8
  store %struct.element* %1, %struct.element** %pe, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %2 = load i64* %i, align 8
  %3 = load %struct.object** %po.addr, align 8
  %numelements = getelementptr inbounds %struct.object* %3, i32 0, i32 4
  %4 = load i64* %numelements, align 8
  %cmp = icmp slt i64 %2, %4
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %5 = load %struct.element** %pe, align 8
  %data = getelementptr inbounds %struct.element* %5, i32 0, i32 3
  %6 = load i8** %data, align 8
  %7 = bitcast i8* %6 to %struct.tri*
  store %struct.tri* %7, %struct.tri** %pt, align 8
  %8 = load %struct.element** %pe, align 8
  %9 = load %struct.tri** %pt, align 8
  call void @TriElementBoundBox(%struct.element* %8, %struct.tri* %9)
  br label %cond.end

cond.true:                                        ; No predecessors!
  br label %cond.end

cond.false:                                       ; No predecessors!
  br label %cond.end

cond.end:                                         ; preds = %for.body, %cond.false, %cond.true
  br label %cond.end.15

cond.true.10:                                     ; No predecessors!
  br label %cond.end.15

cond.false.11:                                    ; No predecessors!
  br label %cond.end.15

cond.end.15:                                      ; preds = %cond.end, %cond.false.11, %cond.true.10
  br label %cond.end.26

cond.true.21:                                     ; No predecessors!
  br label %cond.end.26

cond.false.22:                                    ; No predecessors!
  br label %cond.end.26

cond.end.26:                                      ; preds = %cond.end.15, %cond.false.22, %cond.true.21
  br label %cond.end.36

cond.true.31:                                     ; No predecessors!
  br label %cond.end.36

cond.false.32:                                    ; No predecessors!
  br label %cond.end.36

cond.end.36:                                      ; preds = %cond.end.26, %cond.false.32, %cond.true.31
  br label %cond.end.47

cond.true.42:                                     ; No predecessors!
  br label %cond.end.47

cond.false.43:                                    ; No predecessors!
  br label %cond.end.47

cond.end.47:                                      ; preds = %cond.end.36, %cond.false.43, %cond.true.42
  br label %cond.end.58

cond.true.53:                                     ; No predecessors!
  br label %cond.end.58

cond.false.54:                                    ; No predecessors!
  br label %cond.end.58

cond.end.58:                                      ; preds = %cond.end.47, %cond.false.54, %cond.true.53
  %10 = load %struct.element** %pe, align 8
  %incdec.ptr = getelementptr inbounds %struct.element* %10, i32 1
  store %struct.element* %incdec.ptr, %struct.element** %pe, align 8
  br label %for.inc

for.inc:                                          ; preds = %cond.end.58
  %11 = load i64* %i, align 8
  %inc = add nsw i64 %11, 1
  store i64 %inc, i64* %i, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @TriNormal(%struct.irecord* %hit, double* %Pi, double* %Ni) {
entry:
  %hit.addr = alloca %struct.irecord*, align 8
  %Pi.addr = alloca double*, align 8
  %Ni.addr = alloca double*, align 8
  %pe = alloca %struct.element*, align 8
  %pt = alloca %struct.tri*, align 8
  %pn = alloca [3 x double]*, align 8
  %n0 = alloca [3 x double]*, align 8
  %n1 = alloca [3 x double]*, align 8
  %n2 = alloca [3 x double]*, align 8
  br label %if.end.94

if.then:                                          ; No predecessors!
  br label %if.end

if.then.1:                                        ; No predecessors!
  br label %if.end

if.else:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %if.then, %if.else, %if.then.1
  br label %sw.epilog

sw.bb:                                            ; No predecessors!
  br label %sw.epilog

sw.bb.24:                                         ; No predecessors!
  br label %sw.epilog

sw.bb.37:                                         ; No predecessors!
  br label %sw.epilog

sw.epilog:                                        ; preds = %if.end, %sw.bb.37, %sw.bb.24, %sw.bb
  br label %if.end.94

if.else.84:                                       ; No predecessors!
  br label %if.end.94

if.end.94:                                        ; preds = %entry, %if.else.84, %sw.epilog
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @TriDataNormalize(%struct.object* %po, [4 x double]* %normMat) {
entry:
  %po.addr = alloca %struct.object*, align 8
  %normMat.addr = alloca [4 x double]*, align 8
  %i = alloca i64, align 8
  %coord = alloca [4 x double], align 16
  %pv = alloca [3 x double]*, align 8
  %pt = alloca %struct.tri*, align 8
  %pe = alloca %struct.element*, align 8
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  br label %land.end

land.lhs.true:                                    ; No predecessors!
  br label %land.end

land.rhs:                                         ; No predecessors!
  br label %land.end

land.end:                                         ; preds = %land.lhs.true, %while.cond, %land.rhs
  br label %while.end

while.body:                                       ; No predecessors!
  br label %while.cond

while.end:                                        ; preds = %land.end
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %while.end
  br label %for.end

for.body:                                         ; No predecessors!
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal i64 @TriPeIntersect(%struct.ray* %pr, %struct.element* %pe, %struct.irecord* %hit) {
entry:
  %retval = alloca i64, align 8
  %pr.addr = alloca %struct.ray*, align 8
  %pe.addr = alloca %struct.element*, align 8
  %hit.addr = alloca %struct.irecord*, align 8
  %i = alloca i64, align 8
  %Rd_dot_Pn = alloca double, align 8
  %Ro_dot_Pn = alloca double, align 8
  %q1 = alloca double, align 8
  %q2 = alloca double, align 8
  %tval = alloca double, align 8
  %v1 = alloca [3 x double]*, align 8
  %v2 = alloca [3 x double]*, align 8
  %v3 = alloca [3 x double]*, align 8
  %e1 = alloca [3 x double], align 16
  %e2 = alloca [3 x double], align 16
  %e3 = alloca [3 x double], align 16
  %pt = alloca %struct.tri*, align 8
  br label %cond.end

cond.true:                                        ; No predecessors!
  br label %cond.end

cond.false:                                       ; No predecessors!
  br label %cond.end

cond.end:                                         ; preds = %entry, %cond.false, %cond.true
  br label %return

if.then:                                          ; No predecessors!
  br label %return

if.end:                                           ; No predecessors!
  br label %return

if.then.33:                                       ; No predecessors!
  br label %return

if.end.34:                                        ; No predecessors!
  br label %if.end.54

if.then.37:                                       ; No predecessors!
  br label %if.end.54

if.else:                                          ; No predecessors!
  br label %if.end.54

if.end.54:                                        ; preds = %if.end.34, %if.else, %if.then.37
  br label %return

sw.bb:                                            ; No predecessors!
  br label %return

land.lhs.true:                                    ; No predecessors!
  br label %return

land.lhs.true.119:                                ; No predecessors!
  br label %return

lor.lhs.false:                                    ; No predecessors!
  br label %return

land.lhs.true.125:                                ; No predecessors!
  br label %return

land.lhs.true.128:                                ; No predecessors!
  br label %return

if.then.133:                                      ; No predecessors!
  br label %return

if.end.134:                                       ; No predecessors!
  br label %return

land.lhs.true.147:                                ; No predecessors!
  br label %return

land.lhs.true.152:                                ; No predecessors!
  br label %return

lor.lhs.false.155:                                ; No predecessors!
  br label %return

land.lhs.true.159:                                ; No predecessors!
  br label %return

land.lhs.true.162:                                ; No predecessors!
  br label %return

if.then.167:                                      ; No predecessors!
  br label %return

if.end.168:                                       ; No predecessors!
  br label %return

land.lhs.true.181:                                ; No predecessors!
  br label %return

land.lhs.true.186:                                ; No predecessors!
  br label %return

lor.lhs.false.189:                                ; No predecessors!
  br label %return

land.lhs.true.193:                                ; No predecessors!
  br label %return

land.lhs.true.196:                                ; No predecessors!
  br label %return

if.then.201:                                      ; No predecessors!
  br label %return

if.end.202:                                       ; No predecessors!
  br label %sw.epilog

sw.bb.203:                                        ; No predecessors!
  br label %return

land.lhs.true.229:                                ; No predecessors!
  br label %return

land.lhs.true.234:                                ; No predecessors!
  br label %return

lor.lhs.false.237:                                ; No predecessors!
  br label %return

land.lhs.true.241:                                ; No predecessors!
  br label %return

land.lhs.true.244:                                ; No predecessors!
  br label %return

if.then.249:                                      ; No predecessors!
  br label %return

if.end.250:                                       ; No predecessors!
  br label %return

land.lhs.true.264:                                ; No predecessors!
  br label %return

land.lhs.true.269:                                ; No predecessors!
  br label %return

lor.lhs.false.272:                                ; No predecessors!
  br label %return

land.lhs.true.276:                                ; No predecessors!
  br label %return

land.lhs.true.279:                                ; No predecessors!
  br label %return

if.then.284:                                      ; No predecessors!
  br label %return

if.end.285:                                       ; No predecessors!
  br label %return

land.lhs.true.299:                                ; No predecessors!
  br label %return

land.lhs.true.304:                                ; No predecessors!
  br label %return

lor.lhs.false.307:                                ; No predecessors!
  br label %return

land.lhs.true.311:                                ; No predecessors!
  br label %return

land.lhs.true.314:                                ; No predecessors!
  br label %return

if.then.319:                                      ; No predecessors!
  br label %return

if.end.320:                                       ; No predecessors!
  br label %sw.epilog

sw.bb.321:                                        ; No predecessors!
  br label %return

land.lhs.true.347:                                ; No predecessors!
  br label %return

land.lhs.true.352:                                ; No predecessors!
  br label %return

lor.lhs.false.355:                                ; No predecessors!
  br label %return

land.lhs.true.359:                                ; No predecessors!
  br label %return

land.lhs.true.362:                                ; No predecessors!
  br label %return

if.then.367:                                      ; No predecessors!
  br label %return

if.end.368:                                       ; No predecessors!
  br label %return

land.lhs.true.382:                                ; No predecessors!
  br label %return

land.lhs.true.387:                                ; No predecessors!
  br label %return

lor.lhs.false.390:                                ; No predecessors!
  br label %return

land.lhs.true.394:                                ; No predecessors!
  br label %return

land.lhs.true.397:                                ; No predecessors!
  br label %return

if.then.402:                                      ; No predecessors!
  br label %return

if.end.403:                                       ; No predecessors!
  br label %return

land.lhs.true.417:                                ; No predecessors!
  br label %return

land.lhs.true.422:                                ; No predecessors!
  br label %return

lor.lhs.false.425:                                ; No predecessors!
  br label %return

land.lhs.true.429:                                ; No predecessors!
  br label %return

land.lhs.true.432:                                ; No predecessors!
  br label %return

if.then.437:                                      ; No predecessors!
  br label %return

if.end.438:                                       ; No predecessors!
  br label %sw.epilog

sw.epilog:                                        ; preds = %if.end.438, %if.end.320, %if.end.202
  br label %return

return:                                           ; preds = %land.lhs.true.432, %land.lhs.true.429, %lor.lhs.false.425, %land.lhs.true.422, %land.lhs.true.417, %if.end.403, %land.lhs.true.397, %land.lhs.true.394, %lor.lhs.false.390, %land.lhs.true.387, %land.lhs.true.382, %if.end.368, %land.lhs.true.362, %land.lhs.true.359, %lor.lhs.false.355, %land.lhs.true.352, %land.lhs.true.347, %sw.bb.321, %land.lhs.true.314, %land.lhs.true.311, %lor.lhs.false.307, %land.lhs.true.304, %land.lhs.true.299, %if.end.285, %land.lhs.true.279, %land.lhs.true.276, %lor.lhs.false.272, %land.lhs.true.269, %land.lhs.true.264, %if.end.250, %land.lhs.true.244, %land.lhs.true.241, %lor.lhs.false.237, %land.lhs.true.234, %land.lhs.true.229, %sw.bb.203, %land.lhs.true.196, %land.lhs.true.193, %lor.lhs.false.189, %land.lhs.true.186, %land.lhs.true.181, %if.end.168, %land.lhs.true.162, %land.lhs.true.159, %lor.lhs.false.155, %land.lhs.true.152, %land.lhs.true.147, %if.end.134, %land.lhs.true.128, %land.lhs.true.125, %lor.lhs.false, %land.lhs.true.119, %land.lhs.true, %sw.bb, %if.end.54, %if.end, %cond.end, %sw.epilog, %if.then.437, %if.then.402, %if.then.367, %if.then.319, %if.then.284, %if.then.249, %if.then.201, %if.then.167, %if.then.133, %if.then.33, %if.then
  ret i64 undef
}

; Function Attrs: nounwind uwtable
define internal i64 @TriIntersect(%struct.ray* %pr, %struct.object* %po, %struct.irecord* %hit) {
entry:
  %pr.addr = alloca %struct.ray*, align 8
  %po.addr = alloca %struct.object*, align 8
  %hit.addr = alloca %struct.irecord*, align 8
  %i = alloca i64, align 8
  %nhits = alloca i64, align 8
  %pe = alloca %struct.element*, align 8
  %newhit = alloca %struct.irecord, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br label %for.end

for.body:                                         ; No predecessors!
  br label %if.end.7

if.then:                                          ; No predecessors!
  br label %if.end

if.then.5:                                        ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %if.then, %if.then.5
  br label %if.end.7

if.end.7:                                         ; preds = %for.body, %if.end
  br label %for.inc

for.inc:                                          ; preds = %if.end.7
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i64 undef
}

; Function Attrs: nounwind uwtable
define internal void @TriTransform(%struct.object* %po, [4 x double]* %xtrans, [4 x double]* %xinvT) {
entry:
  %po.addr = alloca %struct.object*, align 8
  %xtrans.addr = alloca [4 x double]*, align 8
  %xinvT.addr = alloca [4 x double]*, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %numelems = alloca i64, align 8
  %vindex = alloca i64*, align 8
  %vptr = alloca [3 x double]*, align 8
  %vp = alloca [3 x double]*, align 8
  %nptr = alloca [3 x double]*, align 8
  %np = alloca [3 x double]*, align 8
  %vp1 = alloca [3 x double]*, align 8
  %vp2 = alloca [3 x double]*, align 8
  %vp3 = alloca [3 x double]*, align 8
  %vec1 = alloca [3 x double], align 16
  %vec2 = alloca [3 x double], align 16
  %pnorm = alloca [4 x double], align 16
  %norm = alloca [4 x double], align 16
  %coord = alloca [4 x double], align 16
  %pt = alloca %struct.tri*, align 8
  %pe = alloca %struct.element*, align 8
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  br label %land.end

land.lhs.true:                                    ; No predecessors!
  br label %land.end

land.rhs:                                         ; No predecessors!
  br label %land.end

land.end:                                         ; preds = %land.lhs.true, %while.cond, %land.rhs
  br label %while.end

while.body:                                       ; No predecessors!
  br label %while.cond

while.end:                                        ; preds = %land.end
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %while.end
  br label %for.end

for.body:                                         ; No predecessors!
  br label %if.end.167

if.then:                                          ; No predecessors!
  br label %if.end

if.then.147:                                      ; No predecessors!
  br label %if.end

if.else:                                          ; No predecessors!
  br label %if.end

if.end:                                           ; preds = %if.then, %if.else, %if.then.147
  br label %if.end.167

if.end.167:                                       ; preds = %for.body, %if.end
  br label %cond.end

cond.true:                                        ; No predecessors!
  br label %cond.end

cond.false:                                       ; No predecessors!
  br label %cond.end

cond.end:                                         ; preds = %if.end.167, %cond.false, %cond.true
  br label %cond.end.187

cond.true.180:                                    ; No predecessors!
  br label %cond.end.187

cond.false.183:                                   ; No predecessors!
  br label %cond.end.187

cond.end.187:                                     ; preds = %cond.end, %cond.false.183, %cond.true.180
  br label %cond.end.200

cond.true.193:                                    ; No predecessors!
  br label %cond.end.200

cond.false.196:                                   ; No predecessors!
  br label %cond.end.200

cond.end.200:                                     ; preds = %cond.end.187, %cond.false.196, %cond.true.193
  br label %if.end.224

land.lhs.true.206:                                ; No predecessors!
  br label %if.end.224

if.then.210:                                      ; No predecessors!
  br label %if.end.224

if.else.211:                                      ; No predecessors!
  br label %if.end.223

land.lhs.true.215:                                ; No predecessors!
  br label %if.end.223

if.then.219:                                      ; No predecessors!
  br label %if.end.223

if.else.221:                                      ; No predecessors!
  br label %if.end.223

if.end.223:                                       ; preds = %land.lhs.true.215, %if.else.211, %if.else.221, %if.then.219
  br label %if.end.224

if.end.224:                                       ; preds = %land.lhs.true.206, %cond.end.200, %if.end.223, %if.then.210
  br label %for.inc

for.inc:                                          ; preds = %if.end.224
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @TriRead(%struct.object* %po, %struct._IO_FILE* %pf) {
entry:
  %po.addr = alloca %struct.object*, align 8
  %pf.addr = alloca %struct._IO_FILE*, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %instat = alloca i64, align 8
  %totalverts = alloca i64, align 8
  %normstr = alloca [5 x i8], align 1
  %pnormals = alloca i64, align 8
  %vnormals = alloca i64, align 8
  %vlist = alloca [3 x double]*, align 8
  %vptr = alloca [3 x double]*, align 8
  %nlist = alloca [3 x double]*, align 8
  %nptr = alloca [3 x double]*, align 8
  %pt = alloca %struct.tri*, align 8
  %pe = alloca %struct.element*, align 8
  store %struct.object* %po, %struct.object** %po.addr, align 8
  store %struct._IO_FILE* %pf, %struct._IO_FILE** %pf.addr, align 8
  %0 = load %struct.object** %po.addr, align 8
  %pelem = getelementptr inbounds %struct.object* %0, i32 0, i32 3
  %1 = load %struct.element** %pelem, align 8
  store %struct.element* %1, %struct.element** %pe, align 8
  %2 = load %struct._IO_FILE** %pf.addr, align 8
  %call = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %2, i8* getelementptr inbounds ([4 x i8]* @.str.4.433, i32 0, i32 0), i64* %totalverts)
  %conv = sext i32 %call to i64
  store i64 %conv, i64* %instat, align 8
  %3 = load i64* %instat, align 8
  %cmp = icmp ne i64 %3, 1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %UnifiedUnreachableBlock

if.end:                                           ; preds = %entry
  %4 = load %struct.object** %po.addr, align 8
  %numelements = getelementptr inbounds %struct.object* %4, i32 0, i32 4
  %5 = load i64* %numelements, align 8
  %mul = mul i64 96, %5
  %call3 = call i8* @GlobalMalloc(i64 %mul, i8* getelementptr inbounds ([6 x i8]* @.str.6.435, i32 0, i32 0))
  %6 = bitcast i8* %call3 to %struct.tri*
  store %struct.tri* %6, %struct.tri** %pt, align 8
  %7 = load i64* %totalverts, align 8
  %add = add nsw i64 %7, 1
  %mul4 = mul i64 24, %add
  %call5 = call i8* @GlobalMalloc(i64 %mul4, i8* getelementptr inbounds ([6 x i8]* @.str.6.435, i32 0, i32 0))
  %8 = bitcast i8* %call5 to [3 x double]*
  store [3 x double]* %8, [3 x double]** %vlist, align 8
  %9 = load i64* %totalverts, align 8
  %mul6 = mul i64 24, %9
  %call7 = call i8* @GlobalMalloc(i64 %mul6, i8* getelementptr inbounds ([6 x i8]* @.str.6.435, i32 0, i32 0))
  %10 = bitcast i8* %call7 to [3 x double]*
  store [3 x double]* %10, [3 x double]** %nlist, align 8
  %11 = load [3 x double]** %vlist, align 8
  store [3 x double]* %11, [3 x double]** %vptr, align 8
  %12 = load [3 x double]** %nlist, align 8
  store [3 x double]* %12, [3 x double]** %nptr, align 8
  %13 = load %struct._IO_FILE** %pf.addr, align 8
  %arraydecay = getelementptr inbounds [5 x i8]* %normstr, i32 0, i32 0
  %call8 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([4 x i8]* @.str.7.436, i32 0, i32 0), i8* %arraydecay)
  %conv9 = sext i32 %call8 to i64
  store i64 %conv9, i64* %instat, align 8
  %14 = load i64* %instat, align 8
  %cmp10 = icmp ne i64 %14, 1
  br i1 %cmp10, label %if.then.12, label %if.end.14

if.then.12:                                       ; preds = %if.end
  br label %UnifiedUnreachableBlock

if.end.14:                                        ; preds = %if.end
  %arrayidx = getelementptr inbounds [5 x i8]* %normstr, i32 0, i64 2
  %15 = load i8* %arrayidx, align 1
  %conv15 = sext i8 %15 to i32
  %cmp16 = icmp eq i32 %conv15, 121
  %cond = select i1 %cmp16, i32 1, i32 0
  %conv18 = sext i32 %cond to i64
  store i64 %conv18, i64* %pnormals, align 8
  %16 = load %struct._IO_FILE** %pf.addr, align 8
  %arraydecay19 = getelementptr inbounds [5 x i8]* %normstr, i32 0, i32 0
  %call20 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %16, i8* getelementptr inbounds ([4 x i8]* @.str.7.436, i32 0, i32 0), i8* %arraydecay19)
  %conv21 = sext i32 %call20 to i64
  store i64 %conv21, i64* %instat, align 8
  %17 = load i64* %instat, align 8
  %cmp22 = icmp ne i64 %17, 1
  br i1 %cmp22, label %if.then.24, label %if.end.26

if.then.24:                                       ; preds = %if.end.14
  br label %UnifiedUnreachableBlock

if.end.26:                                        ; preds = %if.end.14
  %arrayidx27 = getelementptr inbounds [5 x i8]* %normstr, i32 0, i64 2
  %18 = load i8* %arrayidx27, align 1
  %conv28 = sext i8 %18 to i32
  %cmp29 = icmp eq i32 %conv28, 121
  %cond31 = select i1 %cmp29, i32 1, i32 0
  %conv32 = sext i32 %cond31 to i64
  store i64 %conv32, i64* %vnormals, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end.26
  %19 = load i64* %i, align 8
  %20 = load i64* %totalverts, align 8
  %cmp33 = icmp slt i64 %19, %20
  br i1 %cmp33, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %21 = load %struct._IO_FILE** %pf.addr, align 8
  %22 = load [3 x double]** %vptr, align 8
  %arrayidx35 = getelementptr inbounds [3 x double]* %22, i32 0, i64 0
  %23 = load [3 x double]** %vptr, align 8
  %arrayidx36 = getelementptr inbounds [3 x double]* %23, i32 0, i64 1
  %24 = load [3 x double]** %vptr, align 8
  %arrayidx37 = getelementptr inbounds [3 x double]* %24, i32 0, i64 2
  %call38 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %21, i8* getelementptr inbounds ([12 x i8]* @.str.10.439, i32 0, i32 0), double* %arrayidx35, double* %arrayidx36, double* %arrayidx37)
  %conv39 = sext i32 %call38 to i64
  store i64 %conv39, i64* %instat, align 8
  %25 = load i64* %instat, align 8
  %cmp40 = icmp ne i64 %25, 3
  br i1 %cmp40, label %if.then.42, label %if.end.44

if.then.42:                                       ; preds = %for.body
  br label %UnifiedUnreachableBlock

if.end.44:                                        ; preds = %for.body
  %26 = load i64* %vnormals, align 8
  %tobool = icmp ne i64 %26, 0
  br i1 %tobool, label %if.then.45, label %if.end.56

if.then.45:                                       ; preds = %if.end.44
  %27 = load %struct._IO_FILE** %pf.addr, align 8
  %28 = load [3 x double]** %nptr, align 8
  %arrayidx46 = getelementptr inbounds [3 x double]* %28, i32 0, i64 0
  %29 = load [3 x double]** %nptr, align 8
  %arrayidx47 = getelementptr inbounds [3 x double]* %29, i32 0, i64 1
  %30 = load [3 x double]** %nptr, align 8
  %arrayidx48 = getelementptr inbounds [3 x double]* %30, i32 0, i64 2
  %call49 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %27, i8* getelementptr inbounds ([12 x i8]* @.str.10.439, i32 0, i32 0), double* %arrayidx46, double* %arrayidx47, double* %arrayidx48)
  %conv50 = sext i32 %call49 to i64
  store i64 %conv50, i64* %instat, align 8
  %31 = load i64* %instat, align 8
  %cmp51 = icmp ne i64 %31, 3
  br i1 %cmp51, label %if.then.53, label %if.end.55

if.then.53:                                       ; preds = %if.then.45
  br label %UnifiedUnreachableBlock

if.end.55:                                        ; preds = %if.then.45
  %32 = load [3 x double]** %nptr, align 8
  %incdec.ptr = getelementptr inbounds [3 x double]* %32, i32 1
  store [3 x double]* %incdec.ptr, [3 x double]** %nptr, align 8
  br label %if.end.56

if.end.56:                                        ; preds = %if.end.55, %if.end.44
  %33 = load [3 x double]** %vptr, align 8
  %incdec.ptr57 = getelementptr inbounds [3 x double]* %33, i32 1
  store [3 x double]* %incdec.ptr57, [3 x double]** %vptr, align 8
  br label %for.inc

for.inc:                                          ; preds = %if.end.56
  %34 = load i64* %i, align 8
  %inc = add nsw i64 %34, 1
  store i64 %inc, i64* %i, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %35 = load [3 x double]** %vptr, align 8
  %arrayidx58 = getelementptr inbounds [3 x double]* %35, i32 0, i64 0
  store double 1.000000e+32, double* %arrayidx58, align 8
  %36 = load [3 x double]** %vptr, align 8
  %arrayidx59 = getelementptr inbounds [3 x double]* %36, i32 0, i64 1
  store double 1.000000e+32, double* %arrayidx59, align 8
  %37 = load [3 x double]** %vptr, align 8
  %arrayidx60 = getelementptr inbounds [3 x double]* %37, i32 0, i64 2
  store double 1.000000e+32, double* %arrayidx60, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond.61

for.cond.61:                                      ; preds = %for.inc.97, %for.end
  %38 = load i64* %i, align 8
  %39 = load %struct.object** %po.addr, align 8
  %numelements62 = getelementptr inbounds %struct.object* %39, i32 0, i32 4
  %40 = load i64* %numelements62, align 8
  %cmp63 = icmp slt i64 %38, %40
  br i1 %cmp63, label %for.body.65, label %for.end.99

for.body.65:                                      ; preds = %for.cond.61
  %41 = load i64* %pnormals, align 8
  %tobool66 = icmp ne i64 %41, 0
  br i1 %tobool66, label %if.then.67, label %if.end.80

if.then.67:                                       ; preds = %for.body.65
  %42 = load %struct._IO_FILE** %pf.addr, align 8
  %43 = load %struct.tri** %pt, align 8
  %norm = getelementptr inbounds %struct.tri* %43, i32 0, i32 0
  %arrayidx68 = getelementptr inbounds [3 x double]* %norm, i32 0, i64 0
  %44 = load %struct.tri** %pt, align 8
  %norm69 = getelementptr inbounds %struct.tri* %44, i32 0, i32 0
  %arrayidx70 = getelementptr inbounds [3 x double]* %norm69, i32 0, i64 1
  %45 = load %struct.tri** %pt, align 8
  %norm71 = getelementptr inbounds %struct.tri* %45, i32 0, i32 0
  %arrayidx72 = getelementptr inbounds [3 x double]* %norm71, i32 0, i64 2
  %call73 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %42, i8* getelementptr inbounds ([13 x i8]* @.str.13.442, i32 0, i32 0), double* %arrayidx68, double* %arrayidx70, double* %arrayidx72)
  %conv74 = sext i32 %call73 to i64
  store i64 %conv74, i64* %instat, align 8
  %46 = load i64* %instat, align 8
  %cmp75 = icmp ne i64 %46, 3
  br i1 %cmp75, label %if.then.77, label %if.end.79

if.then.77:                                       ; preds = %if.then.67
  br label %UnifiedUnreachableBlock

if.end.79:                                        ; preds = %if.then.67
  br label %if.end.80

if.end.80:                                        ; preds = %if.end.79, %for.body.65
  %47 = load [3 x double]** %vlist, align 8
  %48 = load %struct.tri** %pt, align 8
  %vptr81 = getelementptr inbounds %struct.tri* %48, i32 0, i32 2
  store [3 x double]* %47, [3 x double]** %vptr81, align 8
  %49 = load i64* %vnormals, align 8
  %50 = load %struct.tri** %pt, align 8
  %norminterp = getelementptr inbounds %struct.tri* %50, i32 0, i32 6
  store i64 %49, i64* %norminterp, align 8
  %51 = load %struct._IO_FILE** %pf.addr, align 8
  %52 = load %struct.tri** %pt, align 8
  %vindex = getelementptr inbounds %struct.tri* %52, i32 0, i32 4
  %arrayidx83 = getelementptr inbounds [3 x i64]* %vindex, i32 0, i64 0
  %53 = load %struct.tri** %pt, align 8
  %vindex84 = getelementptr inbounds %struct.tri* %53, i32 0, i32 4
  %arrayidx85 = getelementptr inbounds [3 x i64]* %vindex84, i32 0, i64 1
  %54 = load %struct.tri** %pt, align 8
  %vindex86 = getelementptr inbounds %struct.tri* %54, i32 0, i32 4
  %arrayidx87 = getelementptr inbounds [3 x i64]* %vindex86, i32 0, i64 2
  %call88 = call i32 (%struct._IO_FILE*, i8*, ...) *@fscanf(%struct._IO_FILE* %51, i8* getelementptr inbounds ([12 x i8]* @.str.15.444, i32 0, i32 0), i64* %arrayidx83, i64* %arrayidx85, i64* %arrayidx87)
  %conv89 = sext i32 %call88 to i64
  store i64 %conv89, i64* %instat, align 8
  %55 = load i64* %instat, align 8
  %cmp90 = icmp ne i64 %55, 3
  br i1 %cmp90, label %if.then.92, label %if.end.94

if.then.92:                                       ; preds = %if.end.80
  br label %UnifiedUnreachableBlock

if.end.94:                                        ; preds = %if.end.80
  %56 = load %struct.tri** %pt, align 8
  %57 = bitcast %struct.tri* %56 to i8*
  %58 = load %struct.element** %pe, align 8
  %data = getelementptr inbounds %struct.element* %58, i32 0, i32 3
  store i8* %57, i8** %data, align 8
  %59 = load %struct.object** %po.addr, align 8
  %60 = load %struct.element** %pe, align 8
  %parent = getelementptr inbounds %struct.element* %60, i32 0, i32 2
  store %struct.object* %59, %struct.object** %parent, align 8
  %61 = load %struct.element** %pe, align 8
  %62 = load %struct.tri** %pt, align 8
  call void @TriElementBoundBox(%struct.element* %61, %struct.tri* %62)
  %63 = load %struct.tri** %pt, align 8
  %incdec.ptr95 = getelementptr inbounds %struct.tri* %63, i32 1
  store %struct.tri* %incdec.ptr95, %struct.tri** %pt, align 8
  %64 = load %struct.element** %pe, align 8
  %incdec.ptr96 = getelementptr inbounds %struct.element* %64, i32 1
  store %struct.element* %incdec.ptr96, %struct.element** %pe, align 8
  br label %for.inc.97

for.inc.97:                                       ; preds = %if.end.94
  %65 = load i64* %i, align 8
  %inc98 = add nsw i64 %65, 1
  store i64 %inc98, i64* %i, align 8
  br label %for.cond.61

for.end.99:                                       ; preds = %for.cond.61
  br label %if.end.102

if.then.101:                                      ; No predecessors!
  br label %if.end.102

if.end.102:                                       ; preds = %for.end.99, %if.then.101
  ret void

UnifiedUnreachableBlock:                          ; preds = %if.then.92, %if.then.77, %if.then.53, %if.then.42, %if.then.24, %if.then.12, %if.then
  unreachable
}

; Function Attrs: nounwind uwtable
define internal void @PutJob(i64 %xs, i64 %ys, i64 %xe, i64 %ye, i64 %xbe, i64 %ybe, i64 %pid) {
entry:
  %xs.addr = alloca i64, align 8
  %ys.addr = alloca i64, align 8
  %xe.addr = alloca i64, align 8
  %ye.addr = alloca i64, align 8
  %xbe.addr = alloca i64, align 8
  %ybe.addr = alloca i64, align 8
  %pid.addr = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %xb_addr = alloca i64, align 8
  %yb_addr = alloca i64, align 8
  %xb_end = alloca i64, align 8
  %yb_end = alloca i64, align 8
  %xb_size = alloca i64, align 8
  %yb_size = alloca i64, align 8
  %wpentry = alloca %struct.wpjob*, align 8
  store i64 %xs, i64* %xs.addr, align 8
  store i64 %ys, i64* %ys.addr, align 8
  store i64 %xe, i64* %xe.addr, align 8
  store i64 %ye, i64* %ye.addr, align 8
  store i64 %xbe, i64* %xbe.addr, align 8
  store i64 %ybe, i64* %ybe.addr, align 8
  store i64 %pid, i64* %pid.addr, align 8
  %0 = load i64* %xs.addr, align 8
  store i64 %0, i64* %xb_addr, align 8
  %1 = load i64* %ys.addr, align 8
  store i64 %1, i64* %yb_addr, align 8
  %2 = load i64* %xb_addr, align 8
  %3 = load i64* %xe.addr, align 8
  %add = add nsw i64 %2, %3
  %sub = sub nsw i64 %add, 1
  store i64 %sub, i64* %xb_end, align 8
  %4 = load i64* %yb_addr, align 8
  %5 = load i64* %ye.addr, align 8
  %add1 = add nsw i64 %4, %5
  %sub2 = sub nsw i64 %add1, 1
  store i64 %sub2, i64* %yb_end, align 8
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc.33, %entry
  %6 = load i64* %i, align 8
  %7 = load i64* %ye.addr, align 8
  %cmp = icmp slt i64 %6, %7
  br i1 %cmp, label %for.body, label %for.end.35

for.body:                                         ; preds = %for.cond
  store i64 0, i64* %j, align 8
  br label %for.cond.3

for.cond.3:                                       ; preds = %for.inc, %for.body
  %8 = load i64* %j, align 8
  %9 = load i64* %xe.addr, align 8
  %cmp4 = icmp slt i64 %8, %9
  br i1 %cmp4, label %for.body.5, label %for.end

for.body.5:                                       ; preds = %for.cond.3
  %10 = load i64* %xb_addr, align 8
  %11 = load i64* %xbe.addr, align 8
  %add6 = add nsw i64 %10, %11
  %sub7 = sub nsw i64 %add6, 1
  %12 = load i64* %xb_end, align 8
  %cmp8 = icmp sle i64 %sub7, %12
  br i1 %cmp8, label %if.then, label %if.else

if.then:                                          ; preds = %for.body.5
  %13 = load i64* %xbe.addr, align 8
  store i64 %13, i64* %xb_size, align 8
  br label %if.end

if.else:                                          ; preds = %for.body.5
  %14 = load i64* %xb_end, align 8
  %15 = load i64* %xb_addr, align 8
  %sub9 = sub nsw i64 %14, %15
  %add10 = add nsw i64 %sub9, 1
  store i64 %add10, i64* %xb_size, align 8
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %16 = load i64* %yb_addr, align 8
  %17 = load i64* %ybe.addr, align 8
  %add11 = add nsw i64 %16, %17
  %sub12 = sub nsw i64 %add11, 1
  %18 = load i64* %yb_end, align 8
  %cmp13 = icmp sle i64 %sub12, %18
  br i1 %cmp13, label %if.then.14, label %if.else.15

if.then.14:                                       ; preds = %if.end
  %19 = load i64* %ybe.addr, align 8
  store i64 %19, i64* %yb_size, align 8
  br label %if.end.18

if.else.15:                                       ; preds = %if.end
  %20 = load i64* %yb_end, align 8
  %21 = load i64* %yb_addr, align 8
  %sub16 = sub nsw i64 %20, %21
  %add17 = add nsw i64 %sub16, 1
  store i64 %add17, i64* %yb_size, align 8
  br label %if.end.18

if.end.18:                                        ; preds = %if.else.15, %if.then.14
  %call = call i8* @GlobalMalloc(i64 40, i8* getelementptr inbounds ([11 x i8]* @.str.450, i32 0, i32 0))
  %22 = bitcast i8* %call to %struct.wpjob*
  store %struct.wpjob* %22, %struct.wpjob** %wpentry, align 8
  %23 = load i64* %xb_addr, align 8
  %24 = load %struct.wpjob** %wpentry, align 8
  %xpix = getelementptr inbounds %struct.wpjob* %24, i32 0, i32 1
  store i64 %23, i64* %xpix, align 8
  %25 = load i64* %yb_addr, align 8
  %26 = load %struct.wpjob** %wpentry, align 8
  %ypix = getelementptr inbounds %struct.wpjob* %26, i32 0, i32 0
  store i64 %25, i64* %ypix, align 8
  %27 = load i64* %xb_size, align 8
  %28 = load %struct.wpjob** %wpentry, align 8
  %xdim = getelementptr inbounds %struct.wpjob* %28, i32 0, i32 2
  store i64 %27, i64* %xdim, align 8
  %29 = load i64* %yb_size, align 8
  %30 = load %struct.wpjob** %wpentry, align 8
  %ydim = getelementptr inbounds %struct.wpjob* %30, i32 0, i32 3
  store i64 %29, i64* %ydim, align 8
  %31 = load i64* %pid.addr, align 8
  %32 = load %struct.gmem** @gm, align 8
  %workpool = getelementptr inbounds %struct.gmem* %32, i32 0, i32 7
  %arrayidx = getelementptr inbounds [128 x [256 x %struct.wpjob*]]* %workpool, i32 0, i64 %31
  %arrayidx19 = getelementptr inbounds [256 x %struct.wpjob*]* %arrayidx, i32 0, i64 0
  %33 = load %struct.wpjob** %arrayidx19, align 8
  %tobool = icmp ne %struct.wpjob* %33, null
  br i1 %tobool, label %if.else.21, label %if.then.20

if.then.20:                                       ; preds = %if.end.18
  %34 = load %struct.wpjob** %wpentry, align 8
  %next = getelementptr inbounds %struct.wpjob* %34, i32 0, i32 4
  store %struct.wpjob* null, %struct.wpjob** %next, align 8
  br label %if.end.26

if.else.21:                                       ; preds = %if.end.18
  %35 = load i64* %pid.addr, align 8
  %36 = load %struct.gmem** @gm, align 8
  %workpool22 = getelementptr inbounds %struct.gmem* %36, i32 0, i32 7
  %arrayidx23 = getelementptr inbounds [128 x [256 x %struct.wpjob*]]* %workpool22, i32 0, i64 %35
  %arrayidx24 = getelementptr inbounds [256 x %struct.wpjob*]* %arrayidx23, i32 0, i64 0
  %37 = load %struct.wpjob** %arrayidx24, align 8
  %38 = load %struct.wpjob** %wpentry, align 8
  %next25 = getelementptr inbounds %struct.wpjob* %38, i32 0, i32 4
  store %struct.wpjob* %37, %struct.wpjob** %next25, align 8
  br label %if.end.26

if.end.26:                                        ; preds = %if.else.21, %if.then.20
  %39 = load %struct.wpjob** %wpentry, align 8
  %40 = load i64* %pid.addr, align 8
  %41 = load %struct.gmem** @gm, align 8
  %workpool27 = getelementptr inbounds %struct.gmem* %41, i32 0, i32 7
  %arrayidx28 = getelementptr inbounds [128 x [256 x %struct.wpjob*]]* %workpool27, i32 0, i64 %40
  %arrayidx29 = getelementptr inbounds [256 x %struct.wpjob*]* %arrayidx28, i32 0, i64 0
  store %struct.wpjob* %39, %struct.wpjob** %arrayidx29, align 8
  %42 = load i64* %xbe.addr, align 8
  %43 = load i64* %xb_addr, align 8
  %add30 = add nsw i64 %43, %42
  store i64 %add30, i64* %xb_addr, align 8
  br label %for.inc

for.inc:                                          ; preds = %if.end.26
  %44 = load i64* %xbe.addr, align 8
  %45 = load i64* %j, align 8
  %add31 = add nsw i64 %45, %44
  store i64 %add31, i64* %j, align 8
  br label %for.cond.3

for.end:                                          ; preds = %for.cond.3
  %46 = load i64* %xs.addr, align 8
  store i64 %46, i64* %xb_addr, align 8
  %47 = load i64* %ybe.addr, align 8
  %48 = load i64* %yb_addr, align 8
  %add32 = add nsw i64 %48, %47
  store i64 %add32, i64* %yb_addr, align 8
  br label %for.inc.33

for.inc.33:                                       ; preds = %for.end
  %49 = load i64* %ybe.addr, align 8
  %50 = load i64* %i, align 8
  %add34 = add nsw i64 %50, %49
  store i64 %add34, i64* %i, align 8
  br label %for.cond

for.end.35:                                       ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal i64 @GetJob(%struct.rayjob* %job, i64 %pid) {
entry:
  %retval = alloca i64, align 8
  %job.addr = alloca %struct.rayjob*, align 8
  %pid.addr = alloca i64, align 8
  %wpentry = alloca %struct.wpjob*, align 8
  br label %return

if.then:                                          ; No predecessors!
  br label %return

if.end:                                           ; No predecessors!
  br label %return

return:                                           ; preds = %entry, %if.end, %if.then
  ret i64 undef
}

; Function Attrs: nounwind uwtable
define internal i64 @GetJobs(%struct.rayjob* %job, i64 %pid) {
entry:
  %retval = alloca i64, align 8
  %job.addr = alloca %struct.rayjob*, align 8
  %pid.addr = alloca i64, align 8
  %i = alloca i64, align 8
  br label %return

if.then:                                          ; No predecessors!
  br label %return

if.then.3:                                        ; No predecessors!
  br label %return

if.end:                                           ; No predecessors!
  br label %if.end.4

if.end.4:                                         ; preds = %if.end
  br label %while.cond

while.cond:                                       ; preds = %if.end.15, %if.end.4
  br label %return

while.body:                                       ; No predecessors!
  br label %return

if.then.10:                                       ; No predecessors!
  br label %return

if.then.13:                                       ; No predecessors!
  br label %return

if.end.14:                                        ; No predecessors!
  br label %if.end.15

if.end.15:                                        ; preds = %if.end.14
  br label %while.cond

while.end:                                        ; No predecessors!
  br label %return

return:                                           ; preds = %if.then.10, %while.body, %while.cond, %if.then, %entry, %while.end, %if.then.13, %if.then.3
  ret i64 undef
}

; Function Attrs: nounwind uwtable
define internal void @PrintWorkPool(i64 %pid) {
entry:
  %pid.addr = alloca i64, align 8
  %j = alloca %struct.wpjob*, align 8
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  br label %while.end

while.body:                                       ; No predecessors!
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @InitWorkPool(i64 %pid) {
entry:
  %pid.addr = alloca i64, align 8
  %i = alloca i64, align 8
  %x = alloca i64, align 8
  %y = alloca i64, align 8
  %xe = alloca i64, align 8
  %ye = alloca i64, align 8
  %xsize = alloca i64, align 8
  %ysize = alloca i64, align 8
  store i64 %pid, i64* %pid.addr, align 8
  %0 = load i64* %pid.addr, align 8
  %1 = load %struct.gmem** @gm, align 8
  %workpool = getelementptr inbounds %struct.gmem* %1, i32 0, i32 7
  %arrayidx2 = getelementptr inbounds [128 x [256 x %struct.wpjob*]]* %workpool, i32 0, i64 %0
  %arrayidx3 = getelementptr inbounds [256 x %struct.wpjob*]* %arrayidx2, i32 0, i64 0
  store %struct.wpjob* null, %struct.wpjob** %arrayidx3, align 8
  store i64 0, i64* %i, align 8
  %2 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 5), align 8
  %3 = load i64* @blockx, align 8
  %div = sdiv i64 %2, %3
  store i64 %div, i64* %xsize, align 8
  %4 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 6), align 8
  %5 = load i64* @blocky, align 8
  %div4 = sdiv i64 %4, %5
  store i64 %div4, i64* %ysize, align 8
  store i64 0, i64* %y, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc.20, %entry
  %6 = load i64* %y, align 8
  %7 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 6), align 8
  %cmp = icmp slt i64 %6, %7
  br i1 %cmp, label %for.body, label %for.end.22

for.body:                                         ; preds = %for.cond
  %8 = load i64* %y, align 8
  %9 = load i64* %ysize, align 8
  %add = add nsw i64 %8, %9
  %10 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 6), align 8
  %cmp5 = icmp sgt i64 %add, %10
  br i1 %cmp5, label %if.then, label %if.else

if.then:                                          ; preds = %for.body
  %11 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 6), align 8
  %12 = load i64* %y, align 8
  %sub = sub nsw i64 %11, %12
  store i64 %sub, i64* %ye, align 8
  br label %if.end

if.else:                                          ; preds = %for.body
  %13 = load i64* %ysize, align 8
  store i64 %13, i64* %ye, align 8
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  store i64 0, i64* %x, align 8
  br label %for.cond.6

for.cond.6:                                       ; preds = %for.inc, %if.end
  %14 = load i64* %x, align 8
  %15 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 5), align 8
  %cmp7 = icmp slt i64 %14, %15
  br i1 %cmp7, label %for.body.8, label %for.end

for.body.8:                                       ; preds = %for.cond.6
  %16 = load i64* %x, align 8
  %17 = load i64* %xsize, align 8
  %add9 = add nsw i64 %16, %17
  %18 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 5), align 8
  %cmp10 = icmp sgt i64 %add9, %18
  br i1 %cmp10, label %if.then.11, label %if.else.13

if.then.11:                                       ; preds = %for.body.8
  %19 = load i64* getelementptr inbounds (%struct.display* @Display, i32 0, i32 5), align 8
  %20 = load i64* %x, align 8
  %sub12 = sub nsw i64 %19, %20
  store i64 %sub12, i64* %xe, align 8
  br label %if.end.14

if.else.13:                                       ; preds = %for.body.8
  %21 = load i64* %xsize, align 8
  store i64 %21, i64* %xe, align 8
  br label %if.end.14

if.end.14:                                        ; preds = %if.else.13, %if.then.11
  %22 = load i64* %i, align 8
  %23 = load i64* %pid.addr, align 8
  %cmp15 = icmp eq i64 %22, %23
  br i1 %cmp15, label %if.then.16, label %if.end.17

if.then.16:                                       ; preds = %if.end.14
  %24 = load i64* %x, align 8
  %25 = load i64* %y, align 8
  %26 = load i64* %xe, align 8
  %27 = load i64* %ye, align 8
  %28 = load i64* @bundlex, align 8
  %29 = load i64* @bundley, align 8
  %30 = load i64* %pid.addr, align 8
  call void @PutJob(i64 %24, i64 %25, i64 %26, i64 %27, i64 %28, i64 %29, i64 %30)
  br label %if.end.17

if.end.17:                                        ; preds = %if.then.16, %if.end.14
  %31 = load i64* %i, align 8
  %add18 = add nsw i64 %31, 1
  %32 = load %struct.gmem** @gm, align 8
  %nprocs = getelementptr inbounds %struct.gmem* %32, i32 0, i32 0
  %33 = load i64* %nprocs, align 8
  %rem = srem i64 %add18, %33
  store i64 %rem, i64* %i, align 8
  br label %for.inc

for.inc:                                          ; preds = %if.end.17
  %34 = load i64* %xsize, align 8
  %35 = load i64* %x, align 8
  %add19 = add nsw i64 %35, %34
  store i64 %add19, i64* %x, align 8
  br label %for.cond.6

for.end:                                          ; preds = %for.cond.6
  br label %for.inc.20

for.inc.20:                                       ; preds = %for.end
  %36 = load i64* %ysize, align 8
  %37 = load i64* %y, align 8
  %add21 = add nsw i64 %37, %36
  store i64 %add21, i64* %y, align 8
  br label %for.cond

for.end.22:                                       ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @DeriveInvariant() {
entry:
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @CheckInvariant() {
entry:
  ret void
}

define internal void @RecordSyncVariable() {
entry:
  ret void
}

define internal void @printX() {
entry:
  %0 = load i32* @index_out, align 4
  %idxprom = sext i32 %0 to i64
  %arrayidx = getelementptr inbounds [200 x i8]* @mystring, i32 0, i64 %idxprom
  store i8 88, i8* %arrayidx, align 1
  %1 = load i32* @index_out, align 4
  %inc = add nsw i32 %1, 1
  store i32 %inc, i32* @index_out, align 4
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @appendY() {
entry:
  %0 = load i32* @index_out, align 4
  %idxprom = sext i32 %0 to i64
  %arrayidx = getelementptr inbounds [200 x i8]* @mystring, i32 0, i64 %idxprom
  store i8 89, i8* %arrayidx, align 1
  %1 = load i32* @index_out, align 4
  %inc = add nsw i32 %1, 1
  store i32 %inc, i32* @index_out, align 4
  ret void
}

define internal void @printY() {
entry:
  call void @appendY()
  call void @DecrementCounter()
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @DecrementCounter() {
entry:
  %idx = alloca i32, align 4
  %i = alloca i32, align 4
  %i13 = alloca i32, align 4
  %call = call i32 (...) *@pthread_self()
  store i32 %call, i32* %idx, align 4
  %0 = load i32* %idx, align 4
  %idxprom = zext i32 %0 to i64
  %arrayidx = getelementptr inbounds [3 x i8]* @switches, i32 0, i64 %idxprom
  store i8 0, i8* %arrayidx, align 1
  %1 = load i32* %idx, align 4
  %idxprom1 = zext i32 %1 to i64
  %arrayidx2 = getelementptr inbounds [3 x i32]* @syncID, i32 0, i64 %idxprom1
  %2 = load i32* %arrayidx2, align 4
  %cmp = icmp eq i32 %2, 0
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %3 = load i32* @counter0, align 4
  %dec = add nsw i32 %3, -1
  store i32 %dec, i32* @counter0, align 4
  %4 = load i32* @counter0, align 4
  %cmp3 = icmp eq i32 %4, 0
  br i1 %cmp3, label %if.then.4, label %if.end

if.then.4:                                        ; preds = %if.then
  call void @DeriveInvariant()
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.then.4
  %5 = load i32* %i, align 4
  %cmp5 = icmp slt i32 %5, 3
  br i1 %cmp5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %6 = load i32* %i, align 4
  %idxprom6 = sext i32 %6 to i64
  %arrayidx7 = getelementptr inbounds [3 x i8]* @switches, i32 0, i64 %idxprom6
  store i8 1, i8* %arrayidx7, align 1
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %7 = load i32* %i, align 4
  %inc = add nsw i32 %7, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %if.end

if.end:                                           ; preds = %for.end, %if.then
  %8 = load i32* %idx, align 4
  %idxprom8 = zext i32 %8 to i64
  %arrayidx9 = getelementptr inbounds [3 x i32]* @syncID, i32 0, i64 %idxprom8
  store i32 1, i32* %arrayidx9, align 4
  br label %if.end.25

if.else:                                          ; preds = %entry
  %9 = load i32* @counter1, align 4
  %dec10 = add nsw i32 %9, -1
  store i32 %dec10, i32* @counter1, align 4
  %10 = load i32* @counter1, align 4
  %cmp11 = icmp eq i32 %10, 0
  br i1 %cmp11, label %if.then.12, label %if.end.22

if.then.12:                                       ; preds = %if.else
  call void @DeriveInvariant()
  store i32 0, i32* %i13, align 4
  br label %for.cond.14

for.cond.14:                                      ; preds = %for.inc.19, %if.then.12
  %11 = load i32* %i13, align 4
  %cmp15 = icmp slt i32 %11, 3
  br i1 %cmp15, label %for.body.16, label %for.end.21

for.body.16:                                      ; preds = %for.cond.14
  %12 = load i32* %i13, align 4
  %idxprom17 = sext i32 %12 to i64
  %arrayidx18 = getelementptr inbounds [3 x i8]* @switches, i32 0, i64 %idxprom17
  store i8 1, i8* %arrayidx18, align 1
  br label %for.inc.19

for.inc.19:                                       ; preds = %for.body.16
  %13 = load i32* %i13, align 4
  %inc20 = add nsw i32 %13, 1
  store i32 %inc20, i32* %i13, align 4
  br label %for.cond.14

for.end.21:                                       ; preds = %for.cond.14
  br label %if.end.22

if.end.22:                                        ; preds = %for.end.21, %if.else
  %14 = load i32* %idx, align 4
  %idxprom23 = zext i32 %14 to i64
  %arrayidx24 = getelementptr inbounds [3 x i32]* @syncID, i32 0, i64 %idxprom23
  store i32 0, i32* %arrayidx24, align 4
  br label %if.end.25

if.end.25:                                        ; preds = %if.end.22, %if.end
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @flushAll() {
entry:
  %0 = load i32* @index_out, align 4
  %idxprom = sext i32 %0 to i64
  %arrayidx = getelementptr inbounds [200 x i8]* @mystring, i32 0, i64 %idxprom
  store i8 0, i8* %arrayidx, align 1
  ret void
}

define internal void @printChar(i8 signext %ch) {
entry:
  %ch.addr = alloca i8, align 1
  store i8 %ch, i8* %ch.addr, align 1
  %0 = load i8* %ch.addr, align 1
  %1 = load i32* @index_out, align 4
  %idxprom = sext i32 %1 to i64
  %arrayidx = getelementptr inbounds [200 x i8]* @mystring, i32 0, i64 %idxprom
  store i8 %0, i8* %arrayidx, align 1
  %2 = load i32* @index_out, align 4
  %inc = add nsw i32 %2, 1
  store i32 %inc, i32* @index_out, align 4
  ret void
}

define internal void @waitForAll() {
entry:
  %call = call i32 (i32, i32, ...) *bitcast (i32 (...)* @pthread_join to i32 (i32, i32, ...)*)(i32 0, i32 0)
  call void @flushAll()
  ret void
}

declare i32 @pthread_join(...)

; Function Attrs: nounwind uwtable
define internal void @snapshot(i32 %gvar, i32 %index) {
entry:
  %gvar.addr = alloca i32, align 4
  %index.addr = alloca i32, align 4
  %idx = alloca i32, align 4
  store i32 %gvar, i32* %gvar.addr, align 4
  store i32 %index, i32* %index.addr, align 4
  %call = call i32 (...) *@pthread_self()
  store i32 %call, i32* %idx, align 4
  %0 = load i32* %idx, align 4
  %idxprom = zext i32 %0 to i64
  %arrayidx = getelementptr inbounds [3 x i8]* @switches, i32 0, i64 %idxprom
  %1 = load i8* %arrayidx, align 1
  %tobool = trunc i8 %1 to i1
  br i1 %tobool, label %if.then, label %if.end.5

if.then:                                          ; preds = %entry
  %2 = load i32* %index.addr, align 4
  switch i32 %2, label %sw.default [
    i32 0, label %sw.bb
    i32 1, label %sw.bb.1
    i32 2, label %sw.bb.2
  ]

sw.bb:                                            ; preds = %if.then
  %3 = load i32* %gvar.addr, align 4
  store i32 %3, i32* @gSyncVar_0, align 4
  br label %sw.epilog

sw.bb.1:                                          ; preds = %if.then
  %4 = load i32* %gvar.addr, align 4
  store i32 %4, i32* @gSyncVar_1, align 4
  br label %sw.epilog

sw.bb.2:                                          ; preds = %if.then
  %5 = load i32* %gvar.addr, align 4
  store i32 %5, i32* @gSyncVar_2, align 4
  br label %sw.default

sw.default:                                       ; preds = %sw.bb.2, %if.then
  br label %sw.epilog

sw.epilog:                                        ; preds = %sw.default, %sw.bb.1, %sw.bb
  %6 = load i32* %index.addr, align 4
  %add = add nsw i32 %6, 1
  %7 = load i32* @gSyncVarsTotalNum, align 4
  %cmp = icmp sgt i32 %add, %7
  br i1 %cmp, label %if.then.3, label %if.end

if.then.3:                                        ; preds = %sw.epilog
  %8 = load i32* %index.addr, align 4
  %add4 = add nsw i32 %8, 1
  store i32 %add4, i32* @gSyncVarsTotalNum, align 4
  br label %if.end

if.end:                                           ; preds = %if.then.3, %sw.epilog
  br label %if.end.5

if.end.5:                                         ; preds = %if.end, %entry
  ret void
}

declare i32 @pthread_self(...)

; Function Attrs: nounwind uwtable
define internal void @snapshot64(i64 %gvar, i32 %index) {
entry:
  %gvar.addr = alloca i64, align 8
  %index.addr = alloca i32, align 4
  store i64 %gvar, i64* %gvar.addr, align 8
  store i32 %index, i32* %index.addr, align 4
  %0 = load i64* %gvar.addr, align 8
  %conv = trunc i64 %0 to i32
  %1 = load i32* %index.addr, align 4
  call void @snapshot(i32 %conv, i32 %1)
  ret void
}

define internal void @InitializeSwitchesAndCounter(i32 %id) {
entry:
  %id.addr = alloca i32, align 4
  store i32 %id, i32* %id.addr, align 4
  ret void
}

define internal void @IncrementCounter() {
entry:
  %idx = alloca i32, align 4
  %i = alloca i32, align 4
  %call = call i32 (...) *@pthread_self()
  store i32 %call, i32* %idx, align 4
  %0 = load i32* %idx, align 4
  %idxprom = zext i32 %0 to i64
  %arrayidx = getelementptr inbounds [3 x i32]* @syncID, i32 0, i64 %idxprom
  %1 = load i32* %arrayidx, align 4
  %cmp = icmp eq i32 %1, 0
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %2 = load i32* @counter0, align 4
  %inc = add nsw i32 %2, 1
  store i32 %inc, i32* @counter0, align 4
  %3 = load i32* @counter0, align 4
  %cmp1 = icmp eq i32 %3, 1
  br i1 %cmp1, label %if.then.2, label %if.end

if.then.2:                                        ; preds = %if.then
  call void @CheckInvariant()
  br label %if.end

if.end:                                           ; preds = %if.then.2, %if.then
  %4 = load i8* @firstSync, align 1
  %tobool = trunc i8 %4 to i1
  br i1 %tobool, label %if.then.3, label %if.end.8

if.then.3:                                        ; preds = %if.end
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.then.3
  %5 = load i32* %i, align 4
  %cmp4 = icmp slt i32 %5, 3
  br i1 %cmp4, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %6 = load i32* %i, align 4
  %idxprom5 = sext i32 %6 to i64
  %arrayidx6 = getelementptr inbounds [3 x i8]* @switches, i32 0, i64 %idxprom5
  store i8 1, i8* %arrayidx6, align 1
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %7 = load i32* %i, align 4
  %inc7 = add nsw i32 %7, 1
  store i32 %inc7, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i8 0, i8* @firstSync, align 1
  br label %if.end.8

if.end.8:                                         ; preds = %for.end, %if.end
  br label %if.end.13

if.else:                                          ; preds = %entry
  %8 = load i32* @counter1, align 4
  %inc9 = add nsw i32 %8, 1
  store i32 %inc9, i32* @counter1, align 4
  %9 = load i32* @counter1, align 4
  %cmp10 = icmp eq i32 %9, 1
  br i1 %cmp10, label %if.then.11, label %if.end.12

if.then.11:                                       ; preds = %if.else
  call void @CheckInvariant()
  br label %if.end.12

if.end.12:                                        ; preds = %if.then.11, %if.else
  br label %if.end.13

if.end.13:                                        ; preds = %if.end.12, %if.end.8
  ret void
}

declare i32 @sleep(i32)


