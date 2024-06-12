function concf = findConcByReplacement(tVol, conci,stock,rVol)
    concf=(tVol*conci - rVol*conci + rVol*stock)/tVol;
end