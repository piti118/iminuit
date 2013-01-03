from libcpp.vector cimport vector
from libcpp cimport bool

cdef extern from *:
    ctypedef char* const_char_ptr "const char*"

#LCG Minuit
cdef extern from "Minuit/FCNBase.h":
    cdef cppclass FCNBase:
        double call "operator()" (vector[double] x) except+
        double errorDef()

cdef extern from "Minuit/MnApplication.h":
    cdef cppclass MnApplication:
         FunctionMinimum call "operator()" (int,double) except+

cdef extern from "Minuit/MinuitParameter.h":
    cdef cppclass MinuitParameter:
        MinuitParameter(unsigned int, char*, double)
        unsigned int number()
        char* name()
        double value()
        double error()
        bint isConst()
        bint isFixed()

        bint hasLimits()
        bint hasLowerLimit()
        bint hasUpperLimit()
        double lowerLimit()
        double upperLimit()

cdef extern from "Minuit/MnUserCovariance.h":
    cdef cppclass MnUserCovariance:
        unsigned int nrow()
        double get "operator()" (unsigned int row, unsigned int col)

cdef extern from "Minuit/MnGlobalCorrelationCoeff.h":
    cdef cppclass MnGlobalCorrelationCoeff:
        vector[double] globalCC()
        bint isValid()

cdef extern from "Minuit/MnUserParameterState.h":
    cdef cppclass MnUserParameterState:
        MnUserParameterState()
        MnUserParameterState(MnUserParameterState mpst)
        vector[double] params
        void add(char* name, double val, double err)
        void add(char* name, double val, double err, double , double)
        void add(char*, double)

        vector[MinuitParameter] minuitParameters()
        #MnUserParameters parameters()
        MnUserCovariance covariance()
        MnGlobalCorrelationCoeff globalCC()

        double fval()
        double edm()
        unsigned int nfcn()

        void fix(const_char_ptr)
        void release(const_char_ptr)
        void setValue(const_char_ptr, double)
        void setError(const_char_ptr, double)
        void setLimits(const_char_ptr, double, double)
        void setUpperLimit(const_char_ptr, double)
        void setLowerLimit(const_char_ptr, double)
        void removeLimits(const_char_ptr)

        bint isValid()
        bint hasCovariance()
        bint hasGlobalCC()

        double value(const_char_ptr)
        double error(const_char_ptr)

        unsigned int index(char*)
        char* name(unsigned int)

cdef extern from "Minuit/MnStrategy.h":
    cdef cppclass MnStrategy:
        MnStrategy(unsigned int)


cdef extern from "Minuit/MnMigrad.h":
    cdef cppclass MnMigrad(MnApplication):
        MnMigrad(FCNBase fcn, MnUserParameterState par, MnStrategy str ) except+
        FunctionMinimum call "operator()" (int,double) except+

cdef extern from "Minuit/MnHesse.h":
    cdef cppclass MnHesse:
        MnHesse(unsigned int stra)
        MnUserParameterState call "operator()" (FCNBase , MnUserParameterState, unsigned int maxcalls=0) except+

cdef extern from "Minuit/MnMinos.h":
    cdef cppclass MnMinos:
        MnMinos(FCNBase fcn, FunctionMinimum min, unsigned int stra)
        MinosError minos(unsigned int par, unsigned int maxcalls) except +

cdef extern from "Minuit/MinosError.h":
    cdef cppclass MinosError:
        double lower()
        double upper()
        bint isValid()
        bint lowerValid()
        bint upperValid()
        bint atLowerLimit()
        bint atUpperLimit()
        bint atLowerMaxFcn()
        bint atUpperMaxFcn()
        bint lowerNewMin()
        bint upperNewMin()
        unsigned int nfcn()
        double min()

cdef extern from "Minuit/FunctionMinimum.h":
    cdef cppclass FunctionMinimum:
        FunctionMinimum(FunctionMinimum)
        MnUserParameterState userState()
        MnUserCovariance userCovariance()
        # const_MinimumParameter parameters()
        # const_MinimumError error()

        double fval()
        double edm()
        int nfcn()

        double up()
        bint hasValidParameters()
        bint isValid()
        bint hasValidCovariance()
        bint hasAccurateCovar()
        bint hasPosDefCovar()
        bint hasMadePosDefCovar()
        bint hesseFailed()
        bint hasCovariance()
        bint hasReachedCallLimit()
        bint isAboveMaxEdm()

cdef extern from "Minuit/VariableMetricBuilder.h":
    void set_migrad_print_level "VariableMetricBuilder::setPrintLevel" (int p)
