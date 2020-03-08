/*
 * Cloud9 Parallel Symbolic Execution Engine
 *
 * Copyright (c) 2011, Dependable Systems Laboratory, EPFL
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the Dependable Systems Laboratory, EPFL nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE DEPENDABLE SYSTEMS LABORATORY, EPFL BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * All contributors are listed in CLOUD9-AUTHORS file.
 *
*/

#include "DIMACSSerializer.h"

#include <cassert>
#include <fstream>

namespace cloud9 {

void DIMACSSerializer::addClause(Clause &clause) {
  for (Clause::iterator it = clause.begin(); it != clause.end(); it++) {
    assert(it->first > 0);
  }

  clauses.push_back(clause);
}

void DIMACSSerializer::serialize(std::ostream &os) {
  os << "c " << description << std::endl;
  os << "p cnf " << varCount << " " << clauses.size() << std::endl;

  for (std::vector<Clause>::iterator it = clauses.begin(); it != clauses.end(); it++) {
    for (Clause::iterator cit = it->begin(); cit != it->end(); cit++) {
      if (cit->second)
        os << -cit->first << ' ';
      else
        os << cit->first << ' ';
    }
    os << "0" << std::endl;
  }
}

void DIMACSSerializer::serialize(std::string fileName) {
  std::ofstream fs(fileName.c_str());

  assert(!fs.fail());

  serialize(fs);
}

}