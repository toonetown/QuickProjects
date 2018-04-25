//
//  _test-main.cpp
//  __qp_template__ unit-test
//

// Set up and import the main boost unit test methods
#define BOOST_TEST_MODULE __qp_template__ Unit Tests
#pragma warning(push)
#pragma warning(disable : 4702)	// Unreachable code
#include "boost/test/included/unit_test.hpp"
#pragma warning(pop)

struct GlobalConfig {
    GlobalConfig() {
        // Code here runs before any unit tests
    }
    ~GlobalConfig() {
        // Code here runs after all unit tests
    }
};

BOOST_GLOBAL_FIXTURE(GlobalConfig);
