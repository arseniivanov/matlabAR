function [scaleTransform ]=  findScaleTransform(refDims,repDims)
scaleTransform=affine2d([repDims(1)/refDims(1) 0 0 ; 0 repDims(2)/refDims(2) 0 ;0 0 1]);
end