function [lambda,n_LED,CTF_object0,CTF_object,NA,...
                     pix_CCD,plane_wave_org,plane_wave_new,df,sample_size]=ini_enviroment(d,if_show)
% clc
% clear
%% Objective properties
lambda = 0.532; % wavelength um
k = 2*pi/lambda;
NA = 0.10; %nurmical aperture



%% CCD properties
Mag = 4;
pix_CCD = 128;
pix_SIZ = 6.4;
sample_size = pix_SIZ/Mag * pix_CCD;

fx_CCD = (-pix_CCD/2:pix_CCD/2-1)/(pix_CCD*pix_SIZ/Mag);
df = fx_CCD(2)-fx_CCD(1);
[fx_CCD,fy_CCD] = meshgrid(fx_CCD);
CTF_CCD = (fx_CCD.^2+fy_CCD.^2)<(NA/lambda).^2;
CTF_object0 = CTF_CCD;

ker = fspecial('gaussian',[51,51],3);
noise = mat2gray(imfilter(randn(pix_CCD),ker,'replicate'));

CTF_object = CTF_object0.*exp(1i*0*pi*noise);%;
 imshow((CTF_object),[])

%% LED properties
h_LED = 90; % distance between LED matrix and sample
d_LED =  4; % distance between adjust LED dot
n_LED = 15;     % number of LED
x_LED = -(n_LED/2*d_LED-d_LED/2):d_LED:(n_LED/2*d_LED-d_LED/2);
[x_LED,y_LED] = meshgrid(x_LED);
[xpos,ypos] = getoddseq(n_LED);

R0 = lambda*(d_LED/(lambda*sqrt(d_LED^2+h_LED^2)))/NA;
R_overlap = 1/pi*(2*acos(R0/2)-R0*sqrt(1-(R0/2)^2))



pos_ran = d*randn(2,n_LED^2);

plane_wave_org = zeros(2,n_LED^2); %tilted plane wave
for con = 1:n_LED^2
    v = [0,0,h_LED]-[x_LED(ypos(con),xpos(con)),y_LED(ypos(con),xpos(con)),0];
    v = v/norm(v);
    plane_wave_org(1,con)=v(1);
    plane_wave_org(2,con)=v(2);
end


plane_wave_new = zeros(2,n_LED^2); %tilted plane wave
for con = 1:n_LED^2
    v = [0,0,h_LED]-[x_LED(ypos(con),xpos(con))+pos_ran(1,con),y_LED(ypos(con),xpos(con))+pos_ran(2,con),0];
    v = v/norm(v);
    plane_wave_new(1,con)=v(1);
    plane_wave_new(2,con)=v(2);
end
if if_show
figure1 = figure('Color',[1 1 1]);
ax1 = axes();
hold(ax1,'on');
box(ax1,'on');
plot(plane_wave_org(1,:)/1,plane_wave_org(2,:)/1,'ok','markersize',5,'linewidth',1)
plot(plane_wave_new(1,:)/1,plane_wave_new(2,:)/1,'xr','markersize',8,'linewidth',1)

cc = max(plane_wave_org(:));

axis square
xlim([-1.2*cc,1.2*cc]);
ylim([-1.2*cc,1.2*cc]);
set(ax1,'FontName','Times New Roman','FontSize',15);
hold off;
end

end


function z = getHOA(num,idx,fr,ft,pix_CCD)


%% aberration 
rng(2020);
co = 2*(rand(1,100)-1);
z = zeros(pix_CCD);
count = 0;
for order = 2:8
    for m = (-order):2:order
        count = count+1;
        z(idx) = z(idx) + co(count)*zernfun(order,m,fr(idx),ft(idx));
        if count == num
            break
        end
    end
    if count == num
        break
    end
end
%count
%imshow(mod(z,2*pi),[])
     
end