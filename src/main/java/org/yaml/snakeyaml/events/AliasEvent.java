/**
 * Copyright (c) 2008, SnakeYAML
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */
package org.yaml.snakeyaml.events;

import org.yaml.snakeyaml.error.Mark;

/**
 * Marks the inclusion of a previously anchored node.
 */
public final class AliasEvent extends NodeEvent {

  public AliasEvent(String anchor, Mark startMark, Mark endMark) {
    super(anchor, startMark, endMark);
    if (anchor == null) {
      throw new NullPointerException("anchor is not specified for alias");
    }
  }

  @Override
  public Event.ID getEventId() {
    return ID.Alias;
  }
}
