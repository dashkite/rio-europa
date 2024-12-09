import * as Fn from "@dashkite/joy/function"
import * as K from "@dashkite/katana/async"
import * as Ks from "@dashkite/katana/sync"
import Observable from "@dashkite/observable"
import Europa from "@dashkite/europa"

Event =

  make: ( name ) -> 
    Fn.pipe [
      Ks.read "handle"
      K.mpop ( handle, context ) -> 
        handle.events.enqueue { name, context }
    ]

  from: Fn.pipe [
    Ks.read "handle"
    K.mpop ( handle, specifier ) -> 
      handle.events.enqueue specifier
  ]

Events =

  start: ( machine, start ) ->
    Ks.peek ( handle ) ->
      handle.observable = state = Observable.from forward: [], back: []
      do ->
        handle.events = await Europa.start { state, machine }
        if start? then handle.events.enqueue start
      # avoid returning promise
      return

export { Event, Events }