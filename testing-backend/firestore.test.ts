import {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
  RulesTestEnvironment,
  RulesTestContext,
} from "@firebase/rules-unit-testing";
import { serverTimestamp, Timestamp } from "firebase/firestore";
import { readFileSync } from "fs";

var testEnv: RulesTestEnvironment;
var alice: RulesTestContext;
var bob: RulesTestContext;

beforeAll(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: "rolli-polli",
    firestore: {
      rules: readFileSync("firestore.rules", "utf-8"),
      host: "localhost",
      port: 8080,
    },
  });
});

beforeEach(async () => {
  await testEnv.clearFirestore();
  alice = testEnv.authenticatedContext("alice");
  bob = testEnv.unauthenticatedContext();
});

test("READ poll authentication", async () => {
  const initalData = { question: "answer" };
  await testEnv.withSecurityRulesDisabled((c) =>
    c.firestore().collection("polls").doc("example").set(initalData)
  );
  await assertFails(bob.firestore().collection("polls").doc("example").get());
  expect(
    initalData ==
      (
        await assertSucceeds(
          alice.firestore().collection("polls").doc("example").get()
        )
      ).data()
  );
});

test("CREATE valid poll (global)", async () => {
  await assertSucceeds(
    alice
      .firestore()
      .collection("polls")
      .doc()
      .set({
        ownerID: "alice",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
});

test("CREATE valid poll (local)", async () => {
  await assertSucceeds(
    alice
      .firestore()
      .collection("polls")
      .doc()
      .set({
        ownerID: "alice",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: true,
      })
  );
});

test("CREATE invalid poll (Missing ownerID)", async () => {
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc()
      .set({
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
});

test("CREATE invalid poll (Missing question)", async () => {
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc()
      .set({
        ownerID: "alice",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
});
test("CREATE invalid poll (Missing Options)", async () => {
  await assertFails(
    alice.firestore().collection("polls").doc().set({
      ownerID: "alice",
      question: "Example Question",
      votes: {},
      createdAt: serverTimestamp(),
      local: false,
    })
  );
});
test("CREATE invalid poll (Missing empty votes)", async () => {
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc()
      .set({
        ownerID: "alice",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        createdAt: serverTimestamp(),
        local: false,
      })
  );
});
test("CREATE invalid poll (Missing createdAt)", async () => {
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc()
      .set({
        ownerID: "alice",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        local: false,
      })
  );
});
test("CREATE invalid poll (Missing local/global)", async () => {
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc()
      .set({
        ownerID: "alice",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
      })
  );
});
test("CREATE invalid poll (Different Owner)", async () => {
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc()
      .set({
        ownerID: "bob",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
});

test("CREATE invalid poll (Empty Question)", async () => {
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc()
      .set({
        ownerID: "alice",
        question: "",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
});

test("CREATE invalid poll (Single Option)", async () => {
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc()
      .set({
        ownerID: "bob",
        question: "Example Question",
        options: ["Example Answer 1"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
});

test("CREATE invalid poll (Zero Options)", async () => {
  await assertFails(
    alice.firestore().collection("polls").doc().set({
      ownerID: "alice",
      question: "Example Question",
      options: [],
      votes: {},
      createdAt: serverTimestamp(),
      local: false,
    })
  );
});

test("CREATE invalid poll (Already Voted)", async () => {
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc()
      .set({
        ownerID: "alice",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {
          alice: 1,
        },
        createdAt: serverTimestamp(),
        local: false,
      })
  );
});

test("CREATE invalid poll (Client Timestamp)", async () => {
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc()
      .set({
        ownerID: "alice",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {
          alice: 1,
        },
        createdAt: Timestamp.now(),
        local: false,
      })
  );
});

test("CREATE invalid poll (Empty Document)", async () => {
  await assertFails(alice.firestore().collection("polls").doc().set({}));
});

test("DELETE poll (author)", async () => {
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .set({
        ownerID: "alice",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
  await assertSucceeds(
    alice.firestore().collection("polls").doc("example").delete()
  );
});

test("DELETE poll (unauthorized)", async () => {
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .set({
        ownerID: "bob",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
  await assertFails(
    alice.firestore().collection("polls").doc("example").delete()
  );
});

// Voting
test("UPDATE poll with valid vote", async () => {
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .set({
        ownerID: "charlie",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
  await assertSucceeds(
    alice
      .firestore()
      .collection("polls")
      .doc("example")
      .update({ "votes.alice": 1 })
  );
});

test("UPDATE poll with valid vote (update)", async () => {
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .set({
        ownerID: "charlie",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {
          alice: 0,
        },
        createdAt: serverTimestamp(),
        local: false,
      })
  );
  await assertSucceeds(
    alice
      .firestore()
      .collection("polls")
      .doc("example")
      .update({ "votes.alice": 1 })
  );
});

test("UPDATE poll with invalid vote (out of bounds)", async () => {
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .set({
        ownerID: "charlie",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc("example")
      .update({ "votes.alice": 2 })
  );
});

test("UPDATE poll with invalid vote (negative)", async () => {
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .set({
        ownerID: "charlie",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc("example")
      .update({ "votes.alice": -1 })
  );
});

test("UPDATE poll with invalid vote (string)", async () => {
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .set({
        ownerID: "charlie",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc("example")
      .update({ "votes.alice": "2" })
  );
});

test("UPDATE poll with invalid vote (imposter)", async () => {
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .set({
        ownerID: "bob",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc("example")
      .update({ "votes.charlie": 1 })
  );
});

test("UPDATE poll with invalid vote (self-owned imposter)", async () => {
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .set({
        ownerID: "alice",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc("example")
      .update({ "votes.charlie": 1 })
  );
});

// Comments
test("Create valid comment on poll", async () => {
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .set({
        ownerID: "charlie",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
  await assertSucceeds(
    alice
      .firestore()
      .collection("polls")
      .doc("example")
      .collection("comments")
      .doc()
      .set({
        author: "alice",
        createdAt: serverTimestamp(),
        content: "Example Comment",
      })
  );
});

test("Create valid comment on top level comment", async () => {
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .set({
        ownerID: "charlie",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .collection("comments")
      .doc("example")
      .set({
        author: "bob",
        createdAt: serverTimestamp(),
        content: "Example Comment 3",
      })
  );
  await assertSucceeds(
    alice
      .firestore()
      .collection("polls")
      .doc("example")
      .collection("comments")
      .doc("example")
      .collection("comments")
      .doc()
      .set({
        author: "alice",
        createdAt: serverTimestamp(),
        content: "Example Comment 4",
      })
  );
});

test("Create valid comment on second level comment", async () => {
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .set({
        ownerID: "charlie",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .collection("comments")
      .doc("example")
      .set({
        author: "bob",
        createdAt: serverTimestamp(),
        content: "Example Comment 3",
      })
  );
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .collection("comments")
      .doc("example")
      .collection("comments")
      .doc("example")
      .set({
        author: "dan",
        createdAt: serverTimestamp(),
        content: "Example Comment 4",
      })
  );
  await assertSucceeds(
    alice
      .firestore()
      .collection("polls")
      .doc("example")
      .collection("comments")
      .doc("example")
      .collection("comments")
      .doc("example")
      .collection("comments")
      .doc()
      .set({
        author: "alice",
        createdAt: serverTimestamp(),
        content: "Example Comment 5",
      })
  );
});

test("Create valid comment on poll", async () => {
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .set({
        ownerID: "charlie",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc("example")
      .collection("comments")
      .doc()
      .set({
        author: "dan",
        createdAt: serverTimestamp(),
        content: "Example Comment",
      })
  );
});

test("Create invalid comment on top level comment (mismatch author)", async () => {
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .set({
        ownerID: "charlie",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .collection("comments")
      .doc("example")
      .set({
        author: "bob",
        createdAt: serverTimestamp(),
        content: "Example Comment 3",
      })
  );
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc("example")
      .collection("comments")
      .doc("example")
      .collection("comments")
      .doc()
      .set({
        author: "dan",
        createdAt: serverTimestamp(),
        content: "Example Comment 4",
      })
  );
});

test("Create invalid comment on top level comment (client timestamp)", async () => {
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .set({
        ownerID: "charlie",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .collection("comments")
      .doc("example")
      .set({
        author: "bob",
        createdAt: serverTimestamp(),
        content: "Example Comment 3",
      })
  );
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc("example")
      .collection("comments")
      .doc("example")
      .collection("comments")
      .doc()
      .set({
        author: "alice",
        createdAt: Timestamp.now(),
        content: "Example Comment 4",
      })
  );
});

test("Create invalid comment on top level comment (empty comment)", async () => {
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .set({
        ownerID: "charlie",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .collection("comments")
      .doc("example")
      .set({
        author: "bob",
        createdAt: serverTimestamp(),
        content: "Example Comment 3",
      })
  );
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc("example")
      .collection("comments")
      .doc("example")
      .collection("comments")
      .doc()
      .set({
        author: "alice",
        createdAt: serverTimestamp(),
        content: "",
      })
  );
});

test("Create invalid comment on missing top level comment", async () => {
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .set({
        ownerID: "charlie",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc("example")
      .collection("comments")
      .doc("example")
      .collection("comments")
      .doc()
      .set({
        author: "alice",
        createdAt: serverTimestamp(),
        content: "Example Comment 4",
      })
  );
});

test("Create invalid comment on missing second level comment", async () => {
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .set({
        ownerID: "charlie",
        question: "Example Question",
        options: ["Example Answer 1", "Example Answer 2"],
        votes: {},
        createdAt: serverTimestamp(),
        local: false,
      })
  );
  await testEnv.withSecurityRulesDisabled((c) =>
    c
      .firestore()
      .collection("polls")
      .doc("example")
      .collection("comments")
      .doc("example")
      .set({
        author: "bob",
        createdAt: serverTimestamp(),
        content: "Example Comment 3",
      })
  );
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc("example")
      .collection("comments")
      .doc("example")
      .collection("comments")
      .doc("example")
      .collection("comments")
      .doc()
      .set({
        author: "alice",
        createdAt: serverTimestamp(),
        content: "Example Comment 5",
      })
  );
});

test("Create invalid comment on missing poll", async () => {
  await assertFails(
    alice
      .firestore()
      .collection("polls")
      .doc("example")
      .collection("comments")
      .doc()
      .set({
        author: "alice",
        createdAt: serverTimestamp(),
        content: "Example Comment 4",
      })
  );
});

// User

test("READ user authentication", async () => {
  const initalData = {
    emoji: "$",
    innerColor: "#000000",
    outerColor: "#FFFFFF",
  };
  await testEnv.withSecurityRulesDisabled((c) =>
    c.firestore().collection("users").doc("charlie").set(initalData)
  );
  await assertFails(bob.firestore().collection("users").doc("charlie").get());
  expect(
    initalData ==
      (
        await assertSucceeds(
          alice.firestore().collection("users").doc("charlie").get()
        )
      ).data()
  );
});

test("SET user emoji", async () => {
  await assertSucceeds(
    alice.firestore().collection("users").doc("alice").set(
      {
        emoji: "🦀",
      },
      { merge: true }
    )
  );
});

test("SET user innerColor", async () => {
  await assertSucceeds(
    alice.firestore().collection("users").doc("alice").set(
      {
        innerColor: 0,
      },
      { merge: true }
    )
  );
});

test("SET user outerColor", async () => {
  await assertSucceeds(
    alice.firestore().collection("users").doc("alice").set(
      {
        outerColor: 0,
      },
      { merge: true }
    )
  );
});

test("SET user invalid innerColor", async () => {
  await assertFails(
    alice.firestore().collection("users").doc("alice").set(
      {
        innerColor: "0",
      },
      { merge: true }
    )
  );
});

test("SET user invalid outerColor", async () => {
  await assertFails(
    alice.firestore().collection("users").doc("alice").set(
      {
        outerColor: "0",
      },
      { merge: true }
    )
  );
});

test("SET user invalid innerColor", async () => {
  await assertFails(
    alice.firestore().collection("users").doc("alice").set(
      {
        innerColor: "0",
      },
      { merge: true }
    )
  );
});

test("SET user invalid outerColor", async () => {
  await assertFails(
    alice.firestore().collection("users").doc("alice").set(
      {
        outerColor: "0",
      },
      { merge: true }
    )
  );
});

test("DELETE user profile", async () => {
  await assertFails(
    alice.firestore().collection("users").doc("alice").delete()
  );
});

