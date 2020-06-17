function[rst] = gaussian_kernel(x,y,s)
rst = exp(-norm(x-y)^2/(2*s^2));