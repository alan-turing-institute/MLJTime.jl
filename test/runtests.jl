using MLJTime, CategoricalArrays
using Test

@testset "datapath" begin
    _fpath = joinpath(dirname(@__FILE__), "..", "data/toy.csv")
    X1, y1 = load_dataset(_fpath)
    
    @test X1 == [-0.58291082 0.77026 0.59999317 0.96146749 0.37977839 
    0.84154274 0.37243245 0.21868173 0.84613282 0.57537467 
    0.93855293 0.25818638 0.29248046 0.42564401 0.5711786  
    0.21304496 0.66891344 0.37140495 0.20650268 0.3307044  
    0.71431759 0.8304377  0.1329058  0.36528646 0.91321754 
    0.02603724 0.731184   -0.99851577 0.03834193 0.85909822 
    0.93824209 0.96672667 0.71939988 0.13687903 0.88989899 
    0.88613429 0.22027203 0.74891512 0.80662967 0.19656783 
    0.25738735 -0.85849893 0.29519148 0.76403467 0.32104374 
    0.17287711 0.34066372 0.29485052 0.3625377  0.80875406 
    0.75821559 0.83328172 0.83108783 0.34411894 0.38067706 
    -0.97173602 0.38711375 0.90523631 0.50105462 0.67240828 
    0.49331099 0.47179102 0.68784676 0.81708483 0.22690731 
    0.02193189 0.87135088 0.16605978 0.2785312  0.2463312  
    0.2115269  0.97515003 0.83898221 0.44870931 0.32124904]

    @test y1 == CategoricalArray([-2, 2, 2, 1, 2, 2, -1, 2, 2, 0, 2, 2, -1, 2, 2])
    
    dataset = "BasicMotions"
    _fpath = joinpath(dirname(@__FILE__), "..", "data", dataset, string(dataset, "_", "TEST", ".ts" ))   
    
    X2, y2 = load_from_tsfile_to_NDArray(_fpath)
    
    @test X2[1:20:end, 1:20:end, 1:2:end] == cat([-0.740653 -5.8e-5 -0.106508 -0.153654 -0.278119; -0.294498 0.575243 -0.494393 0.196209 -0.639463],
                                                 [-0.275809 0.134542 0.092941 -0.091092 0.095472; 0.218114 -0.648919 0.191443 -0.5032 0.308612],
                                                 [0.013317 -0.045277 -0.039951 0.005327 0.005327; -0.002663 -0.407496 0.127842 -0.447447 -0.103872], dims=3)

    @test y2[1:8:end] ==  CategoricalArray( ["Standing", "Standing", "Running", "Walking", "Badminton"])

    X3, y3 = load_NDdataset(dataset)

    @test X3[1:20:end, 1:20:end, 1:2:end] == cat([-0.740653 -5.8e-5 -0.106508 -0.153654 -0.278119; -0.294498 0.575243 -0.494393 0.196209 -0.639463; 0.079106 0.241339 -0.269544 -0.332913 -0.129874; -0.071819 1.245053 2.160997 3.774588 3.799607],
            [-0.275809 0.134542 0.092941 -0.091092 0.095472; 0.218114 -0.648919 0.191443 -0.5032 0.308612; 0.551444 0.385068 0.223995 -0.254828 0.207466; 0.275074 0.146363 -1.528987 0.446009 -1.56106],
            [0.013317 -0.045277 -0.039951 0.005327 0.005327; -0.002663 -0.407496 0.127842 -0.447447 -0.103872; 0.02397 -0.25302 0.00799 0.077238 -0.050604; 0.743081 0.098545 0.01598 0.194426 -0.964141], dims=3)

    @test y3[1:8:end] ==  CategoricalArray( ["Standing", "Standing", "Running", "Walking", "Badminton", "Standing", "Standing", "Running", "Walking", "Badminton"])
end 

@testset "interval based forest" begin
    X, y = ts_dataset("Chinatown")
    rng = StableRNG(566) # seed to resproduce the results. 
    
    Interval_features, Intervals = MLJTime.IntervalBasedForest.InvFeatureGen(matrix(X[1:5]), 1, 3, rng);

    #MLJTime.IntervalBasedForest.InvFeatureGen(matrix(X[1:5]), 1, 3, rng)[1]
    @test Interval_features[:, :, 1]  == ([[745.4444444444445 505.0103344571245 56.36945304437562 716.3157894736842 506.93973481750487 39.17543859649122 1057.6 311.9797714240104 -88.88484848484839 1197.5 66.31490531295862 13.4; 
    643.6111111111111 413.3816266853738 45.493292053663545 619.578947368421 415.16761217468587 31.45964912280703 904.5 265.43057263414266 -75.93333333333331 1046.5 36.27211968808366 9.4;
    944.1666666666666 620.4238826138522 100.38906088751294 939.1052631578947 603.3471356374133 83.81228070175439 1421.2 164.37342310185736 -7.357575757575845 1406.75 169.44689433565904 119.1;
    1023.6666666666666 700.7234916603737 62.30340557275547 982.8421052631579 703.8473842750836 40.710526315789444 1366.3 455.57339937953157 -146.3454545454545 1541.5 139.28507936363224 -102.0;
    659.2222222222222 434.21268244349017 67.04643962848297 660.3157894736842 422.00579941138494 57.31754385964911 982.8 108.05327903914397 -15.757575757575758 922.25 88.08092869628476 7.5]])[1]
    
    #MLJTime.IntervalBasedForest.InvFeatureGen( matrix(X[6:10]), Intervals, 1) 
    new_features = [937.6111111111111 627.4576281816954 100.41176470588233 927.8421052631579 611.2641966683922 82.419298245614 1419.6 160.05776734944445 -11.854545454545367 1383.5 133.4778383602811 71.4; 
                    853.0 565.1491213934289 85.80804953560367 838.8947368421053 552.6569052954646 68.70526315789472 1276.1 203.59188479788565 -26.24848484848476 1345.25 139.28717337453102 105.3; 
                    851.6111111111111 573.4303525983306 84.23839009287926 833.2105263157895 563.0164373905345 66.08245614035089 1277.6 223.29860426493192 -41.62424242424238 1351.0 121.72920767013971 89.6; 
                    937.6666666666666 632.3074456958045 99.36016511867906 923.3157894736842 617.6681105066394 80.15087719298245 1419.9 203.8831092126619 -16.951515151515196 1444.75 149.92081243109644 108.5; 
                    857.6666666666666 562.0918911687368 82.0 851.0 547.0275231751242 67.7 1258.6 214.72214603994624 -34.83636363636359 1344.5 117.53722814495839 79.2]
    
    new_features = reshape(new_features, 5, 12, 1)
    @test MLJTime.IntervalBasedForest.InvFeatureGen( matrix(X[6:10]), Intervals, 1)  ==  new_features

    train, test = partition(eachindex(y), 0.7)
    @test unique(y) == [1.0 , 2.0]
    
    model = TimeSeriesForestClassifier(n_trees=3, random_state=rng)
    mach = machine(model, matrix(X[train]), y[train])
    fit!(mach)
    y_pred = predict_mode(mach, matrix(X[test]))
    @test accuracy(y_pred, y[test]) >= 0.75    
end

@testset "distances" begin
    rng = StableRNG(566)
    M = zeros(6, 6)
    FloatMax = maxintfloat(Float64)
    M[1, 2:end] .= FloatMax
    M[2:end, 1] .= FloatMax
    a = rand(rng, Int64, 5)
    b = rand(rng, Int64, 5)
    @test dtw_distance(a, b, -1, M) == -2.9402683278543684e19
end 

@testset "KNN" begin
    X, y = ts_dataset("Chinatown")
    train, test = partition(eachindex(y), 0.7)
    
    A = rand(StableRNG(566), 5, 5)
    index = zeros(5, 3)
    index = MLJTime.select_sort(A, index, 3)
    @test index == [1.0 2.0 3.0; 1.0 3.0 4.0; 3.0 2.0 5.0; 1.0 5.0 4.0; 5.0 2.0 4.0]
    
    model = TimeSeriesKNNClassifier()
    mach = machine(model, matrix(X[train]), y[train])
    fit!(mach)
    y_pred = predict_mode(mach, matrix(X[test]))
    @test accuracy(y_pred, y[test]) >= 0.70    
    
    k = 4
    rng = StableRNG(566) 
    A = rand(rng, 20,30)
    index = zeros(20, k)

    @test MLJTime.select_sort(A, index, k) == [1.0  25.0  19.0   5.0
                             5.0  15.0  11.0  21.0
                            12.0  19.0  17.0  21.0
                            26.0  10.0  25.0   6.0
                            10.0   8.0  23.0   8.0
                            15.0  30.0  19.0  29.0
                            23.0   4.0   5.0  26.0
                             6.0  11.0  18.0  23.0
                            13.0   5.0  29.0  29.0
                            15.0  27.0  27.0  30.0
                            25.0  20.0  13.0  22.0
                            13.0   9.0  27.0  28.0
                            30.0  22.0  10.0   8.0
                            29.0   5.0   9.0  28.0
                            24.0   2.0   3.0   6.0
                            16.0  17.0  21.0  21.0
                            17.0  11.0  15.0  27.0
                            18.0  20.0  12.0  21.0
                            28.0  27.0   7.0  15.0
                            19.0  11.0  23.0  29.0]
end

@testset "Rocket" begin
    #=
    np.random.seed(5)
    kernel = generate_kernels(15, 15)
    XX = np.random.random((15,15))
    apply_kernels_ans = apply_kernels(XX, kernel)
    =#
    apply_kernels_ans = [0.466666667  1.86915069  0.714285714   1.56404946  0.466666667  0.644749239  0.2    0.81511455 0.333333333     0.182182149           0.2   0.391800731  0.266666667  0.260279791 0.666666667 1.40668578 1.0  2.6588065         0.6 1.16076305 0.0  -0.831747841 0.533333333 2.42694389 0.866666667 2.13242483 0.714285714  0.97215377 0.428571429  1.04198929
                         0.666666667   2.7605416  0.428571429   1.17048616          0.4    1.1636767  0.2     1.1492548 0.333333333  0.000722869176   0.266666667   0.965390512          0.2  0.473190683 0.777777778 1.18343075 1.0 1.61479977 0.666666667  2.3053302 0.0  -0.590403203 0.666666667  1.9228075         0.8 1.97877259 0.714285714  1.29059237 0.142857143 0.157695276 
                         0.466666667  2.49380658  0.714285714  0.667454033  0.466666667   1.37855049  0.4   0.500730237 0.333333333     0.207603449   0.333333333   0.704937334  0.333333333  0.507972768         1.0 1.72705702 1.0 1.92037785 0.666666667 2.02551711 0.2   0.373990297 0.733333333 1.59525635 0.866666667  2.0680034 0.571428571  1.29283699 0.428571429 0.544295866
                         0.666666667  3.20101023  0.571428571   1.03278335  0.466666667   1.06228991  0.2   0.630871416 0.333333333     0.627532089   0.133333333    1.15763168  0.266666667  0.391364466 0.888888889  1.5503435 1.0 1.34876186 0.533333333 1.40246686 0.0 -0.0529354498 0.733333333 1.78481358         0.8 1.85289043 0.285714286  2.00849779 0.285714286 0.902233787 
                         0.666666667  2.13769425  0.714285714   1.13289562  0.466666667    1.9158521  0.4   0.998864346         0.0   -0.0485586352   0.333333333   0.350269008  0.266666667  0.786788254 0.888888889 1.14198556 0.8 1.40468465 0.466666667  2.9189426 0.0  -0.109600439 0.666666667 1.78128214 0.733333333  2.6235522 0.428571429  2.18413789 0.571428571  1.29903864 
                         0.533333333   2.9836892  0.428571429   1.45750256          0.4   1.43926618  0.4   0.516466306 0.666666667     0.960756044   0.333333333     1.1196118          0.2   0.76917819 0.888888889 1.05131567 1.0 2.47633094 0.666666667 2.43674043 0.0  -0.925993035         0.6 2.69302784         0.8 2.77034219 0.714285714  2.40433854 0.428571429 0.958647645 
                         0.533333333  1.71039666  0.428571429   1.11807856  0.333333333   1.48710231  0.6    0.22319701         0.0    -0.358080617   0.266666667   0.403950255  0.133333333   0.36698616 0.888888889 1.33615988 1.0 1.57683181         0.4 1.91053745 0.2   0.272680734 0.533333333 2.83349575 0.866666667 1.64220126 0.571428571  2.04472092 0.428571429  0.68234057
                                 0.6  2.40716291  0.571428571  0.672292953          0.4  0.995636869  0.2    0.91441026 0.333333333      0.19570031   0.266666667   0.719213674          0.2   1.00029484         1.0 1.59276171 0.8 1.46403462 0.666666667 1.68903487 0.0  -0.257202796         0.8 2.15746543         0.8 2.33142911 0.285714286  1.58453787 0.285714286 0.276128956 
                                 0.6   2.5495622  0.428571429   1.04375563  0.533333333  0.907804279  0.0  -0.426021734 0.333333333     0.106019564   0.266666667   0.284415817          0.2  0.458375633 0.777777778 1.16355143 1.0 1.78442748 0.466666667 1.35029968 0.0  -0.296840664 0.666666667 1.94336411 0.933333333 1.87213404 0.714285714 0.710278128 0.142857143 0.184764197 
                         0.533333333  1.92622824  0.285714286   1.26193378  0.533333333   1.21053493  0.2   0.330809842 0.333333333     0.182135788   0.266666667    0.51782547  0.133333333  0.091649982 0.777777778 1.53573269 0.6 2.48635508 0.666666667 1.45231436 0.4   0.692076558 0.666666667 2.04981721 0.866666667 2.50377807 0.285714286 0.514873952 0.285714286 0.604855995 
                         0.466666667   2.8742218  0.571428571   1.12958146  0.466666667  0.982245782  0.2   0.502296872 0.333333333     0.529597288           0.4   0.343820151          0.2   0.43421471 0.888888889 1.35043108 0.8 1.35316112 0.533333333 1.95035689 0.2   0.353456767         0.6 2.82308158 0.866666667 2.12306767 0.714285714  2.49379564 0.142857143 0.439333312
                         0.466666667  3.65026892  0.428571429   1.47874248  0.466666667   1.34404919  0.0  -0.140351928 0.333333333     0.859826084   0.333333333   0.803958376  0.333333333  0.569104927 0.777777778 1.57671415 1.0 2.60286486 0.533333333  2.0686166 0.0   -1.21365884 0.666666667 2.55552079         0.8 2.89945514 0.714285714  2.36488639 0.285714286  1.41428386 
                         0.466666667  2.04937001  0.571428571   0.90878341  0.533333333   1.04658181  0.2   0.241451024 0.333333333     0.378097949           0.4   0.364750081  0.133333333  0.322329824 0.666666667 1.65218611 0.8 1.93793206 0.666666667 1.70518721 0.2 0.00126933835 0.666666667 2.20208141 0.933333333 2.08038651 0.571428571   1.4039941 0.285714286  0.57818107 
                         0.666666667  2.27803077  0.571428571   1.43248392  0.666666667   1.01542443  0.2   0.989176771 0.333333333    0.0327688723   0.266666667   0.742917005  0.266666667  0.692247623 0.888888889 1.70813819 1.0 1.49204546 0.533333333 1.76710083 0.0  -0.247371683 0.933333333 1.63840312         0.8 2.21083423 0.285714286  2.72865965 0.428571429 0.938636132
                         0.666666667  1.99437795  0.714285714  0.847532833  0.533333333  0.831622384  0.4   0.712211698 0.333333333      0.60095948           0.4    0.60247533          0.2  0.437287443 0.777777778 1.32221869 0.8 1.69595313 0.533333333 1.72321886 0.0  -0.354538113 0.666666667 2.81551915 0.933333333 2.23133105 0.428571429  2.02749729 0.285714286 0.862765838]
    
    XX = [0.58291082 0.77026    0.59999317 0.96146749 0.37977839 0.49701035 0.33833865 0.74275074 0.30049587 0.79878627 0.08594978 0.23566364 0.43816889 0.12604585 0.20303198
          0.84154274 0.37243245 0.21868173 0.84613282 0.57537467 0.63371648 0.88892854 0.71395906 0.26511267 0.00970831 0.54946346 0.70752623 0.80569461 0.19065633 0.63421428
          0.93855293 0.25818638 0.29248046 0.42564401 0.5711786  0.99005555 0.58819961 0.8878994  0.65621128 0.47277887 0.30554853 0.35017958 0.77713429 0.17750905 0.13793536
          0.21304496 0.66891344 0.37140495 0.20650268 0.3307044  0.08162956 0.43653555 0.81121598 0.44579246 0.44731015 0.02752846 0.27897767 0.0751705  0.04773838 0.86358558
          0.71431759 0.8304377  0.1329058  0.36528646 0.91321754 0.43338789 0.92565181 0.96136808 0.00660811 0.43293059 0.58311263 0.34882757 0.37603202 0.35582158 0.23103288
          0.02603724 0.731184   0.99851577 0.03834193 0.85909822 0.54430493 0.01951996 0.06881641 0.52544948 0.10456021 0.29599743 0.2748344  0.97060571 0.46966648 0.28518106
          0.93824209 0.96672667 0.71939988 0.13687903 0.88989899 0.44126029 0.78612738 0.72148873 0.65316408 0.76697313 0.81183026 0.46166154 0.48462061 0.09738624 0.37086277
          0.88613429 0.22027203 0.74891512 0.80662967 0.19656783 0.76460265 0.65734626 0.97545921 0.38829315 0.75675    0.84395362 0.37907264 0.22368808 0.3682424  0.65282988
          0.25738735 0.85849893 0.29519148 0.76403467 0.32104374 0.50432241 0.87418372 0.48539667 0.62418851 0.34280804 0.4685735  0.06141402 0.51976649 0.44915414 0.29898286
          0.17287711 0.34066372 0.29485052 0.3625377  0.80875406 0.89559956 0.91503332 0.42155562 0.89844751 0.58707759 0.9966111  0.12426284 0.75683156 0.58826857 0.51456602
          0.75821559 0.83328172 0.83108783 0.34411894 0.38067706 0.59528513 0.04287195 0.81470528 0.5860231  0.44350472 0.63813487 0.95535158 0.80421115 0.65614969 0.20754234
          0.97173602 0.38711375 0.90523631 0.50105462 0.67240828 0.88740297 0.05838575 0.29474664 0.17769359 0.04656562 0.34180828 0.91540073 0.25271628 0.11303782 0.94184494
          0.49331099 0.47179102 0.68784676 0.81708483 0.22690731 0.20235285 0.42449878 0.84759295 0.9271214  0.19040336 0.68945921 0.44586868 0.87811028 0.2956111  0.27020385
          0.02193189 0.87135088 0.16605978 0.2785312  0.2463312  0.92205218 0.08162816 0.33665844 0.68043503 0.16556516 0.5776585  0.42465708 0.01314008 0.60660289 0.34691688
          0.2115269  0.97515003 0.83898221 0.44870931 0.32124904 0.01409788 0.72806984 0.26632355 0.51168995 0.62601907 0.75290599 0.15814617 0.09131661 0.77406715 0.05145793]

    weights   = [0.52762177, -0.0418873, 0.2471347, -1.31156877, -0.7247638, -0.78220244, -1.63412477, 2.7437687, -0.46801041, 0.01399379, 1.43003853, -0.68828345, 1.79152578, -0.19943179, -0.12082104, -0.18071698, -0.06975319, -0.47113781, 0.78166691, -0.84304843, 0.40557851, -1.27548192, 0.5544292, 0.44486959, -0.76179568, -0.84353163, -0.27708717, 0.05488085, 0.93928732, 0.81888716, -0.06003624, 1.42705634, -1.65799853, -1.03679063, -0.92473863, 0.80497937, -0.45438938, 1.91288138, 0.30939407, -0.22241857, -0.78292932, 0.62495391, -0.08524614, 0.18349484, -0.16950302, -0.60015582, -0.02692903, -0.56489894, 1.2632381, 0.74928421, 0.13981419, -0.25654669, 0.31853533, 0.04552576, -0.12017115, -1.26448862, -0.93308081, 1.32112779, -0.48612077, 0.68934027, -0.64064021, 0.42020047, 0.29536018, -0.919411, 0.64127106, -1.0641436, -0.31604487, -0.26644779, 1.58622318, -0.05704011, 0.36556408, -0.2481109, 0.60494258, 0.81612145, 0.83206467, -0.72643367, -0.13443512, -0.08208581, 0.09331525, -1.41730465, 1.06946835, -1.01957853, -0.03607454, 0.30114602, -2.20579273, 0.62166328, -0.1753795, 0.89379478, 1.76691169, -1.20234354, -1.28683233, -0.34219971, -1.06585416, -0.00949176, 0.89073309, 0.61441468, 0.35051293, 0.68524821, 0.13848917, 0.25151074, -0.22653086, -0.51363513, -1.01036993, -1.41547553, 0.32466544, 1.0371033, 1.47076476, 0.10694709, -0.75073608, 2.03104583, -0.51633515, 0.35914072, 0.74269627, -0.7995558, -1.0662558, 1.92427295, -0.67610275, -0.78531807, 0.48564705, -2.31143814, 0.02183875, 0.72847231, -0.58188375, 1.19451164, -0.85269623, 0.85391231, 0.82931092, -0.11102697, 1.39071293, -0.88898299, -0.52789062, 0.74821341, -1.44155276] 
    lengths   = Int32[11, 9, 11, 11, 7, 9, 7, 7, 11, 7, 11, 7, 7, 9, 9]
    biases    = [0.68675053, 0.092913, 0.13270275, -0.79834545, -0.10765975, -0.28003361, -0.33196979, 0.62634105, 0.87208684, 0.05435767, -0.80174301, 0.45357874, 0.68722719, 0.28728044, -0.46194353]
    dilations = Int32[1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1]
    paddings  = Int32[5, 0, 5, 0, 0, 4, 3, 0, 0, 6, 0, 3, 3, 0, 0]
    kernel = (weights, lengths, biases, dilations, paddings)
    
    @test  apply_kernels_ans≈ MLJTime.apply_kernels(XX,  kernel)

    #First call to the apply_kernel from apply_kernels above
    _X = [0.58291082, 0.77026, 0.59999317, 0.96146749, 0.37977839, 0.49701035, 0.33833865, 0.74275074, 0.30049587, 0.79878627, 0.08594978, 0.23566364, 0.43816889, 0.12604585, 0.20303198]
    _W = [0.52762177, -0.0418873, 0.2471347, -1.31156877, -0.7247638, -0.78220244, -1.63412477, 2.7437687, -0.46801041, 0.01399379, 1.43003853]
    _b = 0.68675053
    _l = Int32(11)
    _d = Int32(1)
    _p = Int32(5)
    
    a1, b1 = MLJTime.apply_kernel(_X, _W, _l, _b, _d, _p) 
    @test [a1, b1] ≈ [0.4666666666666667, 1.8691506816260883]
    weights, lengths, biases, dilations, paddings = MLJTime.generate_kernels(15, 15, 7)

    @test weights ≈ [0.20946987493470082, -0.021718758503254144, -0.35951714229923665, 0.17766188099745459, 0.40425359989114706, 0.9886081558231362, -0.7235728429911245, -0.7135888321389559, -1.2907160470203496, 0.8154160336360065, 0.5137040776704755, 0.26705111541213455, 0.47480026067660186, -0.197433071782658, 0.8514380635347026, -1.1617410473217324, -0.5431985964128231, 1.5337553835792397, -0.9629980600363045, -0.3973236396398957, -0.5189584581534508, 0.6546080501441861, 1.1208914028438155, -0.9332987829367986, -1.2557000343846472, 1.97997778832397, -0.8032049044041798, -1.4914342896826653, -1.105116662846912, 2.2640505338150367, 0.22383494927238068, -0.8229957681968434, 0.40361938080221244, -0.09327281427504056, -0.38282837155719585, -0.006372117026678892, 0.37582940303743456, -1.3496111434628901, 1.0940947490566022, 0.8910453473847659, 1.3020851484712181, -1.4115938142335838, -1.8726707563013845, -0.5848275170017244, 0.7431312211457688, 0.002465333213452936, -1.3981813569061972, 0.6561763106662478, 0.39852633887157674, 1.979348393298065, -0.9644818569568242, 0.9115730204189727, 0.12894086955204645, 1.718847157480878, 0.4955071820760768, 0.9188853578634907, -0.07067906593016868, 1.1847939270970322, -0.6229087888143605, -1.9185289193095396, -1.017424876293943, -0.6884919741694657, 0.652572062227571, -0.418483589977059, 1.1648263125150844, 0.12294055598670936, -0.22819443867015932, -1.0030830431507949, 0.4664791719419216, -0.341923305037045, -0.41513372583622815, -0.94524137793961, -1.2667442495182606, 1.6670739764664197, 0.11812368259705572, -0.22024569176706776, 0.8950805784363284, -0.7244193234267298, -0.7005788090737236, 0.6733433052776924, 0.6960649140820706, -0.19245700513417496, -2.348695501162304, 0.37730101924239223, 0.7052894414572141, -0.0931194561563581, 0.09121605364122187, -0.28375281929574153, -0.3388894308598973, 0.6268529843735299, 1.2637977087599426, 0.1965496693210121, 0.07924973428707299, -0.5010732418408879, -0.5736084100456836, -0.43274047658426484, 2.3133118468919385, -1.0816891220291873, 0.007095451682842702, -0.4368638452825783, -0.9533895065804225, 1.34448396464174, 0.7536292293935183, -0.5632524121470226, 0.18769651463338782, 0.24964568420867894, -0.5890450805501444, -1.5305063517644388, 0.848617318611738, -0.5771588150162538, -0.15434029777233785, -0.5069098623945345, 2.1842911895575816, -0.2639931812217544, 1.2668523211590947, -0.22196659877176117, 1.0512934657270945, -0.8346988959485406, -0.34305368115640067, -0.4339573550589728, -0.26061000823313407, -1.5832393795793775, 1.3593801318619982, -0.7638210991522643, 0.19341078852347915, 1.258420261976951, 1.2735382514792994, -0.8461291933410995, -1.4807043315046715, 0.3652853220183056, -1.234523036665802, 0.8729394696506795, 0.2788889225292732, -2.100613545364331, 0.2776841973243349, 1.047318794033346, 0.8583051984924995] 
    @test lengths ≈ Int32[11, 11, 9, 11, 11, 9, 9, 11, 9, 7, 9, 7, 9, 7, 7]
    @test biases ≈ [-0.6035360765327771, 0.27249020484592235, 0.232263762639199, 0.417408084884888, -0.9926165669796312, 0.9531982209784409, 0.4176193131947299, 0.6251074449871927, -0.7788867556531662, 0.10914409688356663, 0.9935072895394153, 0.8385655813087447, -0.9835519116179752, 0.9193276717480652, -0.4225756505399385]
    @test dilations ≈ Int32[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2]
    @test paddings ≈ Int32[0, 5, 4, 0, 5, 4, 4, 5, 4, 0, 4, 0, 0, 3, 0]    
end

#=

=#