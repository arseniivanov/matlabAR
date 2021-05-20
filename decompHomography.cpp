#include "opencvmex.hpp"
#include <opencv2/calib3d.hpp>

using namespace cv;
using namespace std;

void checkInputs(int nrhs)
{
    if (nrhs != 2)
    {
        mexErrMsgTxt("Incorrect number of inputs. Function expects H and K matrix.");
    }
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    checkInputs(nrhs);
    // convert inputs from column-major mxArray to row-major cv::Mat
    Mat H, K;
    ocvMxArrayToMat_double(prhs[0], H);
    ocvMxArrayToMat_double(prhs[1], K);
    // do decomposition and get a number of solutions
    vector<Mat> Rs_decomp, ts_decomp, normals_decomp;
    int solutions = decomposeHomographyMat(H, K, Rs_decomp, ts_decomp, normals_decomp);
   // transform the solutions for column-major output mxArray
    for(int i = 0; i < solutions*3;i = i+3){
        plhs[i] = ocvMxArrayFromImage_double(Rs_decomp[i/3]);
        plhs[i+1] = ocvMxArrayFromImage_double(ts_decomp[i/3]);
        plhs[i+2] = ocvMxArrayFromImage_double(normals_decomp[i/3]);
    }
}