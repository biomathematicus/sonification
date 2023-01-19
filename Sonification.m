function Sonification()
% By Juan B. Gutierrez 
% @biomathematicus
% biomathematicus.me

    % First, create a dummy surface with a color map representing an
    % additional dimension
    x = 1:.1:10; y = 1:.1:10; z = sin(x)'*cos(x); 
    fig = figure(1);
    surf(x,y,z);
    colormap([1,0,0; 1,1,1]); 
    
    % Now, add the handler to the cursor event in the plot
    h = datacursormode(fig);
    set(h,'UpdateFcn',@DataCursorSound)
end

function txt = DataCursorSound(empt,event_obj)
% By Juan B. Gutierrez 
% @biomathematicus
% biomathematicus.me

    try
        % Retrieve position in the plot
        pos = get(event_obj,'Position');

        % This is an artificial way of generating 
        tonic = floor(pos(1));
        if bitor(tonic==0,tonic==9), tonic = 4; end

        key = 220 + tonic*100/abs(pos(3));
        fs = 44100;
        tonic = 1;
        seconds = 0.5;
        Triad(key, tonic, 'min', 'per', fs, seconds);

        sFeature1 = num2str(pos(1));
        sFeature2 = num2str(pos(2));
        sFeature3 = num2str(pos(3));
        fFeature4 = sign(pos(3));
        if fFeature4==1, sFeature4 = 'White'; else sFeature4 = 'Red'; end
        sFeature5 = num2str(key); 

        % Customizes text of data tips
         txt = {
                    ['Dimension 1: ',sFeature1],...
                    ['Dimension 2: ',sFeature2],...
                    ['Dimension 3: ',sFeature3],...
                    ['Dimension 4: ',sFeature4],...
                    ['Dimension 5: ',sFeature5],...
               };
    catch err
        txt = '';
    end
end
      
function y = Triad(key, tonic, third, fifth, fs, seconds)
% By: Ryan McGee
% Source: http://www.lifeorange.com/MATLAB/MATLAB_music.htm

    %establish tonic
    if tonic == 1
        ton = 0;
    elseif tonic == 2
        ton = 2;
    elseif tonic == 3
        ton = 4;
    elseif tonic == 4
        ton = 5;
    elseif tonic == 5
        ton = 7;
    elseif tonic == 6
        ton = 9;
    elseif tonic == 7
        ton = 11;
    elseif tonic == 8 
        ton = 12;
    end

    %establish third
    if third == 'min'
        c1 = 3;
    elseif third == 'maj'
        c1 = 4;
    end

    %establish fifth
    if fifth == 'aug'
        c2 = 8;
    elseif fifth == 'dim'
        c2 = 6;
    elseif fifth == 'per'
        c2 = 7;
    end

    %Set up discrete-time vector
    n = [1:seconds*fs];

    f1 = key/fs;
    f1 = f1*2^(ton/12);
    f2 = f1*2^(c1/12);
    f3 = f1*2^(c2/12);

    A1 = 1;
    A2 = 1;
    A3 = 1;

    %Build your waveform
    y = A1*sin(2*pi*f1*n);
    y = y + A2*sin(2*pi*f2*n);
    y = y + A3*sin(2*pi*f3*n);

    soundsc(y,fs);
end

