% Gauss
function [f] = FCT_density_function(x,stand,mu);
f = 1/(stand*sqrt(2*pi))*exp(-0.5*((x-mu)/stand).^2);
end


