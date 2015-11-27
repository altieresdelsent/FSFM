function [ ] = saveVideo(file,frames )
%saveVideo Summary of this function goes here
%   Detailed explanation goes here
 writerObj = VideoWriter( file,'MPEG-4');
 open(writerObj);
 writeVideo(writerObj,frames);
 close(writerObj);


end

