
function f = normalize(x)
    delta = max(x)-min(x);
    for i = 1:1:length(x)
        p(i) = (x(i)-min(x))/delta;
    end
    f = p;
end