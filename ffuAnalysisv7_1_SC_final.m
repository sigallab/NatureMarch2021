%%%THIS SCRIPT FINDS FOCI IN A MICROWELL IMAGE AND OUTPUTS A MATRIX SAVED
%%%AS AN EXCEL FILE resultsFFU.xlsx WHICH HAS A MAP OF THE RAW NUMBER OF FOCI
%%%PER WELL

%%%By Alex Sigal, 2021

clearvars

close all;

%%%debug mode

debug =0; %%%use for initial determination of filtering - 
%%%1. Run on all images and check quality control folder for errors.
%%%2. Change parameters below, then re-run on problem images.
%%%3. Re-run all images

%%%Laplacian filter

sigmaVal = 0.5;%%%relavent param! change sigma on test image to find optimal

alphaVal = 3.0;

%%%Inner circle - all outside is cropped out to prevent edge of well being
%%%included. In pixels

radiusCircle = 492;


%%%Lower and upper bounds for objects in pixels - exclude objects too small
%%%or too large to be foci
LB=30; 
UB = 10000;

%%%%%%

%%%dir is directory, exp is experiment

 for exp =1:14


     %%%%Neuts 8-12
         if exp ==1
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\8thNeut6518_28_01_2021';
         elseif exp ==2
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\8thNeut1313_28_01_2021';
         elseif exp ==3
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\9thNeut1313p2_02_02_21';
         elseif exp ==4
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\9thNeut6518p2_02_02_21';
         elseif exp ==5
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\9thNeut1313p1_02_02_21';
         elseif exp ==6
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\9thNeut6518p1_02_02_21';
         elseif exp ==7
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\10thNeut6518p3_06_02_21';
         elseif exp ==8
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\10thNeut6518p2_06_02_21';
         elseif exp ==9
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\10thNeut1313p3_06_02_21';
         elseif exp ==10
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\10thNeut1313p2_06_02_21';
         elseif exp ==11
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\10thNeut1313p1_06_02_21';
         elseif exp ==12
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\10thNeut6518p1_06_02_21';
         elseif exp ==13
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\11thNeut1313_10_02_21';
         elseif exp ==14
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\11thNeut6518_10_02_21';
         elseif exp ==15
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\12thNeut1313p1_13_02_21';
         elseif exp ==16
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\12thNeut6518p1_13_02_21';
         elseif exp ==17
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\12thNeut1313p2_13_02_21';
         elseif exp ==18
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\12thNeut6518p2_13_02_21';
         elseif exp ==19
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\12thNeut1313p3_13_02_21';
         elseif exp ==20
                dir = 'C:\SAforBackup\papersInProgress\abEscape\allSandileNeuts\12thNeut6518p3_13_02_21';
         end

    prefix = 'ffu_s';

    timepointInName =0;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%Start image segmentation

    cd(dir)

    dirQC = 'qualityControl';

    mkdir(dirQC);

    dirStretched = 'stretchedIm';

    mkdir(dirStretched)

    vectorResults = zeros(1, 96);

    for imNum = 1:96

        if timepointInName ==1
            imFfu = imread([dir '\' prefix num2str(imNum) '_t1.TIF']);

        else

            imFfu = imread([dir '\' prefix num2str(imNum) '.TIF']);

        end

            imFfuStretch = imadjust(imFfu,stretchlim(imFfu),[]);

        outputStretched =([dir '\' dirStretched '\' 'stIm' num2str(imNum) '.TIF']);

        imwrite(imFfuStretch ,outputStretched, 'tif', 'Compression', 'none') ;

        if debug ==1
            figure, imshow(imFfuStretch);
        end



        sigma = sigmaVal;%%%relavent param! change sigma on test image to find optimal

        alpha = alphaVal;

        filtIm =locallapfilt(imFfuStretch, sigma, alpha);

        if debug ==1
            figure, imshow(filtIm);
        end

        imFfuCompPre = imcomplement(filtIm);

        if debug ==1
            figure, imshow(imFfuCompPre);
        end

        %%%Binarize

        level = graythresh(imFfuCompPre);

        BWpre = imbinarize(imFfuCompPre,level);

        if debug ==1
            figure, imshow(BWpre);
        end

        %%%take out small objects: single cells and the large ring around well due
        %%%to contrast effects. [LB UB]
        BWring = bwpropfilt(BWpre,'Area',[LB UB]);

        if debug ==1
            figure, imshow(BWring);
        end

        %%%Fill holes
        BWringCompNoHoles = imfill(BWring, 'holes');

        if debug ==1
            figure, imshow(BWringCompNoHoles);

        else
            f= figure('visible','off');
            imshow(BWringCompNoHoles);
        end

       %%%Take out edge of well
        circ = drawcircle('Center',[512,512],'Radius',radiusCircle);

        BWcircle = createMask(circ);

        if debug ==0
            close all;
        end

        BWringCompNoHolesCirc = immultiply(BWringCompNoHoles, BWcircle);

        if debug ==1
            figure, imshow(BWringCompNoHolesCirc);
        end

        %%%Segment objects

         L = bwlabel(BWringCompNoHolesCirc);

         S = regionprops(L,{'Centroid','PixelIdxList'});

         centlist= cat(1, S.Centroid);

          if debug ==0

             figure1=figure('visible','off');

          else

             figure1=figure;

          end

         imshow(imFfuStretch);

         %%%Add object number for quality control

        if numel(centlist)>0  %objects exist

             for index = 1:numel(centlist(:,1))

             h=text(centlist(index,1),centlist(index,2),num2str(index));

                              set(h, 'Color', [1 0 1]);
             end

        end

         outputNameOverlay =([dir '\' dirQC '\' 'overlayNum' num2str(imNum) '.TIF']);

          print(outputNameOverlay,'-dtiff')

          if debug ==0
              close all
          end

          %%%Save object number into vector of results, each index is image

           if numel(centlist)>0           
              vectorResults(imNum) = numel(centlist(:,1)); % number of objects   
           else

               vectorResults(imNum) = 0;

           end

    end     

    %%%%IMPORTANT: Reshape vector of results into plate map matrix
    %%%BECAUSE PLATE READ AS SNAKE, EVERY SECOND ROW WILL BE FLIPPED. EG, IMAGE
    %%%NUMBER 13 WILL BE WELL 24

     %%%vertical snake on full plate
    matrixResults=[vectorResults(1:8)', vectorResults(16:-1:9)', vectorResults(17:24)',...
        vectorResults(32:-1:25)', vectorResults(33:40)', vectorResults(48:-1:41)',...
        vectorResults(49:56)', vectorResults(64:-1:57)', vectorResults(65:72)', vectorResults(80:-1:73)',...;
        vectorResults(81:88)', vectorResults(96:-1:89)'];

    filename= 'resultsFFU.xlsx';
    xlswrite(filename,matrixResults);
end



