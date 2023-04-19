function eve = EVE(wall_e)
global S

eve = PTB_OBJECTS.VIDEO.EVE();
eve.LinkToWindowPtr(S.PTB.Video.wPtr);
eve.GetScreenSize();

eve.va2pix   = S.PTB.Video.va2pix;

eve.wall_e = wall_e;

eve.dim           = S.TaskParam.EVE.dim;
eve.excentricity  = S.TaskParam.EVE.excentricity;
eve.color.yellow  = S.TaskParam.EVE.color.yellow;

eve.GenCenter();

eve.img.happy = PTB_OBJECTS.VIDEO.Image();
eve.img.happy.filename = S.TaskParam.EVE.img.happy;
eve.img.happy.LinkToWindowPtr(S.PTB.Video.wPtr);
eve.img.happy.GetScreenSize();
eve.img.happy.LoadAndColorizeAlpha(S.TaskParam.EVE.color.yellow);
eve.img.happy.mask = 'NoMask';
eve.img.happy.scale = eve.va2pix * S.TaskParam.EVE.dim / eve.img.happy.baseRect(4);
eve.img.happy.MakeTexture();

eve.img.sad = PTB_OBJECTS.VIDEO.Image();
eve.img.sad.filename = S.TaskParam.EVE.img.sad;
eve.img.sad.LinkToWindowPtr(S.PTB.Video.wPtr);
eve.img.sad.GetScreenSize();
eve.img.sad.LoadAndColorizeAlpha(S.TaskParam.EVE.color.yellow);
eve.img.sad.mask = 'NoMask';
eve.img.sad.scale = eve.va2pix * S.TaskParam.EVE.dim / eve.img.sad.baseRect(4);
eve.img.sad.MakeTexture();

end % function