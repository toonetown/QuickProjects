//
//  hello_test.cpp
//  __qp_template__
//
#include <boost/test/unit_test.hpp>
#include "hello.h"

// Fixture for our suite
struct HelloFixture {
    HelloFixture() {
        // Code here runs before each test in this suite
    }
    ~HelloFixture() {
        // Code here runs after each test in this suite
    }
};

// Register the fixture with our suite
BOOST_FIXTURE_TEST_SUITE(HelloTest, HelloFixture);

// An example test case
BOOST_AUTO_TEST_CASE(TestSayHello) {
    BOOST_CHECK_EQUAL(SayHello("World"), "Hello, World!");
}

// Remember to end your suite
BOOST_AUTO_TEST_SUITE_END();
