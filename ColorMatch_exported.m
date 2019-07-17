classdef ColorMatch_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        GridLayout                matlab.ui.container.GridLayout
        LeftPanel                 matlab.ui.container.Panel
        RedSliderLabel            matlab.ui.control.Label
        RedSlider                 matlab.ui.control.Slider
        GreenSliderLabel          matlab.ui.control.Label
        GreenSlider               matlab.ui.control.Slider
        BlueSliderLabel           matlab.ui.control.Label
        BlueSlider                matlab.ui.control.Slider
        SubmitButton              matlab.ui.control.Button
        StartButton               matlab.ui.control.Button
        ScoreEditFieldLabel       matlab.ui.control.Label
        ScoreEditField            matlab.ui.control.NumericEditField
        CumulativeEditFieldLabel  matlab.ui.control.Label
        CumulativeEditField       matlab.ui.control.NumericEditField
        TrialEditFieldLabel       matlab.ui.control.Label
        TrialEditField            matlab.ui.control.NumericEditField
        RightPanel                matlab.ui.container.Panel
        UIAxes                    matlab.ui.control.UIAxes
        UIAxes_2                  matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    
    properties (Access = private)
        
        init % Initial image
        targ % Target image
        ii = 1; % Counter
        D % Score Record
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
        
            msgbox('Welcome to ColorMatch. Press the START button, attempt to match the color on the top display as close as possible using the three sliders, then press SUBMIT. Aim for a score below 3 after 10 trials!')
        
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {480, 480};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {220, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end

        % Button pushed function: SubmitButton
        function SubmitButtonPushed(app, event)
%             app.ScoreEditField.Value = {num2str(app.targ(1,1,1)) num2str(app.targ(1,1,2)) num2str(app.targ(1,1,3))};
              A = [app.init(1,1,1) app.init(1,1,2) app.init(1,1,3)];
              B = [app.targ(1,1,1) app.targ(1,1,2) app.targ(1,1,3)];
              app.D(app.ii) = norm(im2double(B-A));
              app.ScoreEditField.Value = app.D(app.ii);
              app.TrialEditField.Value = app.ii;
              app.ii = app.ii+1;
              app.CumulativeEditField.Value = sum(app.D);
              %app.init = ones(size(app.init,1),size(app.init,2),3,'uint8')
              %app.init = uint8(255.*rand(size(app.init)));
              app.init = uint8( ones(size(app.init)).*(255.*rand(1,1,3)) );
              image(app.UIAxes,app.init)
        end

        % Button pushed function: StartButton
        function StartButtonPushed(app, event)
           % app.init = uint8( ones(size(app.init)).*(255.*rand(1,1,3)) );    
            app.init = zeros(app.UIAxes.Position(3),app.UIAxes.Position(4),3,'uint8');
            app.init = uint8( ones(size(app.init)).*(255.*rand(1,1,3)) );    
            image(app.UIAxes,app.init)
            app.targ = uint8( ones(size(app.init)).*(255.*rand(1,1,3)) );
            image(app.UIAxes_2,app.targ)
        end

        % Value changed function: RedSlider
        function RedSliderValueChanged(app, event)
           % value = app.RedSlider.Value;
           % app.targ(:,:,1) = value;
          %  image(app.UIAxes_2,app.targ)
            %app.ScoreEditField.Value = {num2str(app.RedSlider.Value) num2str(app.GreenSlider.Value) num2str(app.BlueSlider.Value)};
        end

        % Value changed function: GreenSlider
        function GreenSliderValueChanged(app, event)
            %value = app.GreenSlider.Value;
            %app.targ(:,:,2) = value;
            %image(app.UIAxes_2,app.targ)
            %app.ScoreEditField.Value = {num2str(app.RedSlider.Value) num2str(app.GreenSlider.Value) num2str(app.BlueSlider.Value)};
        end

        % Value changed function: BlueSlider
        function BlueSliderValueChanged(app, event)
            %value = app.BlueSlider.Value;
            %app.targ(:,:,3) = value;
           % image(app.UIAxes_2,app.targ)
           % app.ScoreEditField.Value = {num2str(app.RedSlider.Value) num2str(app.GreenSlider.Value) num2str(app.BlueSlider.Value)};
        end

        % Value changing function: RedSlider
        function RedSliderValueChanging(app, event)
            changingValue = event.Value;
            app.targ(:,:,1) = changingValue;
            image(app.UIAxes_2,app.targ)
        end

        % Value changing function: GreenSlider
        function GreenSliderValueChanging(app, event)
            changingValue = event.Value;
            app.targ(:,:,2) = changingValue;
            image(app.UIAxes_2,app.targ)
        end

        % Value changing function: BlueSlider
        function BlueSliderValueChanging(app, event)
            changingValue = event.Value;
            app.targ(:,:,3) = changingValue;
            image(app.UIAxes_2,app.targ)
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {220, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create RedSliderLabel
            app.RedSliderLabel = uilabel(app.LeftPanel);
            app.RedSliderLabel.HorizontalAlignment = 'right';
            app.RedSliderLabel.Position = [10 399 27 22];
            app.RedSliderLabel.Text = 'Red';

            % Create RedSlider
            app.RedSlider = uislider(app.LeftPanel);
            app.RedSlider.Limits = [0 255];
            app.RedSlider.MajorTicks = [];
            app.RedSlider.ValueChangedFcn = createCallbackFcn(app, @RedSliderValueChanged, true);
            app.RedSlider.ValueChangingFcn = createCallbackFcn(app, @RedSliderValueChanging, true);
            app.RedSlider.MinorTicks = [];
            app.RedSlider.Position = [58 408 150 3];

            % Create GreenSliderLabel
            app.GreenSliderLabel = uilabel(app.LeftPanel);
            app.GreenSliderLabel.HorizontalAlignment = 'right';
            app.GreenSliderLabel.Position = [-1 345 38 22];
            app.GreenSliderLabel.Text = 'Green';

            % Create GreenSlider
            app.GreenSlider = uislider(app.LeftPanel);
            app.GreenSlider.Limits = [0 255];
            app.GreenSlider.MajorTicks = [];
            app.GreenSlider.ValueChangedFcn = createCallbackFcn(app, @GreenSliderValueChanged, true);
            app.GreenSlider.ValueChangingFcn = createCallbackFcn(app, @GreenSliderValueChanging, true);
            app.GreenSlider.MinorTicks = [];
            app.GreenSlider.Position = [58 354 150 3];

            % Create BlueSliderLabel
            app.BlueSliderLabel = uilabel(app.LeftPanel);
            app.BlueSliderLabel.HorizontalAlignment = 'right';
            app.BlueSliderLabel.Position = [8 296 29 22];
            app.BlueSliderLabel.Text = 'Blue';

            % Create BlueSlider
            app.BlueSlider = uislider(app.LeftPanel);
            app.BlueSlider.Limits = [0 255];
            app.BlueSlider.MajorTicks = [];
            app.BlueSlider.ValueChangedFcn = createCallbackFcn(app, @BlueSliderValueChanged, true);
            app.BlueSlider.ValueChangingFcn = createCallbackFcn(app, @BlueSliderValueChanging, true);
            app.BlueSlider.MinorTicks = [];
            app.BlueSlider.Position = [58 305 150 3];

            % Create SubmitButton
            app.SubmitButton = uibutton(app.LeftPanel, 'push');
            app.SubmitButton.ButtonPushedFcn = createCallbackFcn(app, @SubmitButtonPushed, true);
            app.SubmitButton.Position = [62 154 100 22];
            app.SubmitButton.Text = 'Submit';

            % Create StartButton
            app.StartButton = uibutton(app.LeftPanel, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
            app.StartButton.Position = [62 219 100 22];
            app.StartButton.Text = 'Start';

            % Create ScoreEditFieldLabel
            app.ScoreEditFieldLabel = uilabel(app.LeftPanel);
            app.ScoreEditFieldLabel.HorizontalAlignment = 'right';
            app.ScoreEditFieldLabel.Position = [45 95 37 22];
            app.ScoreEditFieldLabel.Text = 'Score';

            % Create ScoreEditField
            app.ScoreEditField = uieditfield(app.LeftPanel, 'numeric');
            app.ScoreEditField.HorizontalAlignment = 'center';
            app.ScoreEditField.Position = [97 95 65 22];

            % Create CumulativeEditFieldLabel
            app.CumulativeEditFieldLabel = uilabel(app.LeftPanel);
            app.CumulativeEditFieldLabel.HorizontalAlignment = 'right';
            app.CumulativeEditFieldLabel.Position = [16 52 66 22];
            app.CumulativeEditFieldLabel.Text = 'Cumulative';

            % Create CumulativeEditField
            app.CumulativeEditField = uieditfield(app.LeftPanel, 'numeric');
            app.CumulativeEditField.HorizontalAlignment = 'center';
            app.CumulativeEditField.Position = [97 52 65 22];

            % Create TrialEditFieldLabel
            app.TrialEditFieldLabel = uilabel(app.LeftPanel);
            app.TrialEditFieldLabel.HorizontalAlignment = 'right';
            app.TrialEditFieldLabel.Position = [45 14 37 22];
            app.TrialEditFieldLabel.Text = 'Trial #';

            % Create TrialEditField
            app.TrialEditField = uieditfield(app.LeftPanel, 'numeric');
            app.TrialEditField.HorizontalAlignment = 'center';
            app.TrialEditField.Position = [97 14 65 22];

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.RightPanel);
            title(app.UIAxes, '')
            xlabel(app.UIAxes, '')
            ylabel(app.UIAxes, '')
            app.UIAxes.PlotBoxAspectRatio = [1.65714285714286 1 1];
            app.UIAxes.TickLength = [0 0];
            app.UIAxes.XColor = 'none';
            app.UIAxes.XTick = [];
            app.UIAxes.YColor = 'none';
            app.UIAxes.YTick = [];
            app.UIAxes.Position = [60 264 300 185];

            % Create UIAxes_2
            app.UIAxes_2 = uiaxes(app.RightPanel);
            title(app.UIAxes_2, '')
            xlabel(app.UIAxes_2, '')
            ylabel(app.UIAxes_2, '')
            app.UIAxes_2.PlotBoxAspectRatio = [1.65714285714286 1 1];
            app.UIAxes_2.TickLength = [0 0];
            app.UIAxes_2.XColor = 'none';
            app.UIAxes_2.XTick = [];
            app.UIAxes_2.YColor = 'none';
            app.UIAxes_2.YTick = [];
            app.UIAxes_2.Position = [60 35 300 185];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ColorMatch_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end