//   Copyright (c) 2018 PaddlePaddle Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "paddle/fluid/framework/details/ssa_graph_executor.h"

#include "paddle/fluid/framework/details/fetch_async_op_handle.h"

namespace paddle {
namespace framework {
namespace details {
SSAGraphExecutor::~SSAGraphExecutor() = default;

void ClearFetchOp(ir::Graph* graph, std::vector<OpHandleBase*>* fetch_ops) {
  if (fetch_ops->empty()) return;

  for (auto& op : *fetch_ops) {
    PADDLE_ENFORCE_EQ(dynamic_cast<FetchOpHandle*>(op) != nullptr ||
                          dynamic_cast<FetchAsyncOpHandle*>(op) != nullptr,
                      true,
                      platform::errors::PreconditionNotMet(
                          "The input ops of ClearFetchOp function should be "
                          "FetchOpHandle or FetchAsyncOpHandle."));
    for (auto& out_var : op->Node()->outputs) {
      graph->RemoveNode(out_var);
    }
    for (auto& in_var : op->Inputs()) {
      in_var->RemoveOutput(op, op->Node());
    }
    graph->RemoveNode(op->Node());
  }
  fetch_ops->clear();
}

}  // namespace details
}  // namespace framework
}  // namespace paddle
