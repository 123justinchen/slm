
add_heds_path;

% Check if the installed SDK supports the required API version
heds_requires_version(3);

% Make some enumerations available locally to avoid too much code:
heds_types;

% Detect SLMs and open a window on the selected SLM:
heds_slm_init;

% Open the SLM preview window (might have an impact on performance):
show_slm_preview(1.0);

% Configure the blank screen where overlay is applied to:
grayValue = 128;
grayValueOffset = -128; % this value is applied also as a beam manipulation later.

% Configure beam manipulation in physical units:
wavelength_nm = 780.0;  % wavelength of incident laser light

p=0.5;

        steering_angle_x_deg = p;
        steering_angle_y_deg = p;

focal_length_mm = 320.0;

% Upload a datafield into the GPU. The datafield just consists of a single pixel with the grayValue and will
% automatically be extended into full SLM screen due to "PresetAutomatic" show flag.
% The heds_load_data() call creates a handle which refers to the grayValue data.
handle = heds_load_data(uint8(grayValue));

% Wait for the data to be processed internally to speed up the heds_show_datahandle(handle) call later:
heds_datahandle_waitfor(handle.id, heds_state.ReadyToRender);

% Make the data without overlay visible on SLM screen:
heds_show_datahandle(handle.id);

% Wait 2 seconds until we apply the beam manipulation to make the uploaded data visible first:
heds_utils_wait_s(2.0);



% for f=1:30
%     for u=0:2
%         steering_angle_x_deg = p-0.03*u;
%         steering_angle_y_deg = p-0.03*u;

        for t=0:0.1:2.2*pi
            steering_angle_x_deg1 = 0 + steering_angle_x_deg*cos(t);
            steering_angle_y_deg1 = 0 + steering_angle_y_deg*sin(t);
                
            % Calculate proper parameters to pass to the data handle:
            beam_lens_param = heds_utils_beam_lens_from_focal_length_mm(wavelength_nm, focal_length_mm);
            beam_steer_x_param = heds_utils_beam_steer_from_angle_deg(wavelength_nm, steering_angle_x_deg1);
            beam_steer_y_param = heds_utils_beam_steer_from_angle_deg(wavelength_nm, steering_angle_y_deg1);
    
            % Now, after heds_load_data(), we apply values to the beam manipulation parameters of the handle:
            handle.beamSteerX = beam_steer_x_param;
            handle.beamSteerY = beam_steer_y_param;
            handle.beamLens = beam_lens_param;
            % The handle.valueOffset is given in float gray values (like in heds_show_data(single(data))).
            % Actually addressed 8-bit gray values in range [0, 255] translate to float gray values in range [0, 1].
            % Both ranges typically translate to a phase shift in range [0 rad, (255/256)*2pi rad] due to the phase calibration
            % of the SLM and to make the addressed phase values periodic, i.e. gray value 256 must equal gray value 0.
            handle.valueOffset = grayValueOffset/255;
            
            % Apply the beam steering values from the handle structure to the SLM Display SDK.
            % This will take effect on SLM screen directly, because we made the handle visible before applying values.
            % Of course we also can apply the parameters before showing the handle on screen.
            % We explicitly pass which values to apply by using the "heds_datahandle_applyvalue" flags:
%             handle.transformShiftX = -5;
%             handle.transformShiftY = -20;
            %handle.transformScale = .5;



            heds_datahandle_apply(handle, heds_datahandle_applyvalue.BeamManipulation + heds_datahandle_applyvalue.ValueOffset + heds_datahandle_applyvalue.Transform);
            heds_utils_wait_ms(100);
            % Now the data should have changed by our beam manipulations.
        end
       
        
%     end
%     focal_length_mm = focal_length_mm +10;
% end
heds_show_phasevalues(128);



% Please uncomment to close SDK at the end:
% heds_utils_wait_s(8.0);
% heds_close_slm
