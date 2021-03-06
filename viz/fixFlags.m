function FLAGS = fixFlags(FLAGS)
% fixFlags : fixes and initializes flags for superSeggerViewer.
%
%   INPUT :
%       FLAGS : previous flags
%   OUTPUT : 
%       FLAGS : fixed flags
% 
% Copyright (C) 2016 Wiggins Lab 
% Written by Paul Wiggins, Stella Stylianidou, Connor Brennan.
% University of Washington, 2016
% This file is part of SuperSegger.
% 
% SuperSegger is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% SuperSegger is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with SuperSegger.  If not, see <http://www.gnu.org/licenses/>.


% displays legend for regions/ poles
if ~isfield(FLAGS,'legend')
    FLAGS.legend = 1;
end


% displays cell numbers instead of region numbers
if ~isfield(FLAGS,'cell_flag')
    FLAGS.cell_flag  = 1;
end

if ~isfield(FLAGS,'m_flag')
    FLAGS.m_flag  = 0;
end

% displays cell ids/regions ids
if ~isfield(FLAGS,'ID_flag')
    FLAGS.ID_flag  = 0;
end

% tight - does not allow modification of segments
if ~isfield(FLAGS,'T_flag')
    FLAGS.T_flag  = 0;
end

% shows region fills
if ~isfield(FLAGS,'P_flag')
    FLAGS.P_flag  = 1;
end

% shows region outlines
if ~isfield(FLAGS,'Outline_flag')
    FLAGS.Outline_flag  = 0;
end

% shows errors
if ~isfield(FLAGS,'e_flag')
    FLAGS.e_flag  = 0;
end

% shows fluorescence channel given in f_flag 
if ~isfield(FLAGS,'f_flag')
    FLAGS.f_flag  = 0;
end

% shows composite image of all fluor channels found
if ~isfield(FLAGS,'composite')
    FLAGS.composite  = 0;
end

% shows poles
if ~isfield(FLAGS,'p_flag')
    FLAGS.p_flag  = 0;
end

% shows foci scores
if ~isfield(FLAGS,'s_flag')
    FLAGS.s_flag  = 1;
end


if ~isfield(FLAGS,'c_flag')
    FLAGS.c_flag  = 1;
end


% shows filtered fluorescence
if ~isfield(FLAGS,'filt')
    FLAGS.filt = 1;
end

% shows phase image or mask if it is 0
if ~isfield(FLAGS, 'phase_flag');
    FLAGS.phase_flag = 1;
end

% modifies the transparency of the phase/mask - use as double from 0 - 1
if ~isfield(FLAGS, 'phase_level');
    FLAGS.phase_level = 1;
end

% not used
if ~isfield(FLAGS,'lyse_flag')
    FLAGS.lyse_flag = 0;
end

% shows regions scores
if ~isfield(FLAGS,'regionScores')
    FLAGS.regionScores = 0;
end

% uses seg files 
if ~isfield(FLAGS,'useSegs')
    FLAGS.useSegs = 0;
end

% shows linking from frame to frame 
if ~isfield(FLAGS,'showLinks')
    FLAGS.showLinks = 0;
end

% shows linking with mothers
if ~isfield(FLAGS,'showMothers')
    FLAGS.showMothers = 0;
end

% shows linking with daughters
if ~isfield(FLAGS,'showDaughters')
    FLAGS.showDaughters = 0;
end

end