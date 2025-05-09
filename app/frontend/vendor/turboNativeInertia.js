window.TurboSession = null;


(() => {
  const TURBO_LOAD_TIMEOUT = 4000

  // Bridge between Turbo JS and native code. Built for Turbo 7
  class TurboNative {
    registerAdapter() {
      // if (window.Turbo) {
      //   Turbo.registerAdapter(this)
      TurboSession.turboIsReady(true) // If Inertia is ready
      // } else {
      //   throw new Error("Failed to register the TurboNative adapter")
      // }
    }


    pageLoaded() {
      let restorationIdentifier = ""

      // TODO: Check how to handle this in inertia
      // if (window.Turbo) {
      //   restorationIdentifier = Turbo.navigator.restorationIdentifier
      // }

      this.afterNextRepaint(function () {
        TurboSession.pageLoaded(restorationIdentifier)
      })
    }

    pageLoadFailed() {
      TurboSession.turboFailedToLoad()
    }

    visitLocationWithOptionsAndRestorationIdentifier(location, optionsJSON, restorationIdentifier) {
      let options = JSON.parse(optionsJSON)
      let action = options.action

      if (window.Turbo) {
        if (Turbo.navigator.locationWithActionIsSamePage(new URL(location), action)) {
          // Skip the same-page anchor scrolling behavior for visits initiated from the native
          // side. The page content may be stale and we want a fresh request from the network.
          Turbo.navigator.startVisit(location, restorationIdentifier, {"action": "replace"})
        } else {
          Turbo.navigator.startVisit(location, restorationIdentifier, options)
        }
      }
    }

    // Current visit

    issueRequestForVisitWithIdentifier(identifier) {
      if (identifier == this.currentVisit.identifier) {
        this.currentVisit.issueRequest()
      }
    }

    changeHistoryForVisitWithIdentifier(identifier) {
      if (identifier == this.currentVisit.identifier) {
        this.currentVisit.changeHistory()
      }
    }

    loadCachedSnapshotForVisitWithIdentifier(identifier) {
      if (identifier == this.currentVisit.identifier) {
        this.currentVisit.loadCachedSnapshot()
      }
    }

    loadResponseForVisitWithIdentifier(identifier) {
      if (identifier == this.currentVisit.identifier) {
        this.currentVisit.loadResponse()
      }
    }

    cancelVisitWithIdentifier(identifier) {
      if (identifier == this.currentVisit.identifier) {
        this.currentVisit.cancel()
      }
    }

    visitRenderedForColdBoot(visitIdentifier) {
      this.afterNextRepaint(function () {
        TurboSession.visitRendered(visitIdentifier)
      })
    }

    // Adapter interface

    visitProposedToLocation(location, options) {
      if (window.Turbo && Turbo.navigator.locationWithActionIsSamePage(location, options.action)) {
        // Scroll to the anchor on the page
        TurboSession.visitProposalScrollingToAnchor(location.toString(), JSON.stringify(options))
        Turbo.navigator.view.scrollToAnchorFromLocation(location)
      } else if (window.Turbo && Turbo.navigator.location?.href === location.href) {
        // Refresh the page without native proposal
        TurboSession.visitProposalRefreshingPage(location.toString(), JSON.stringify(options))
        this.visitLocationWithOptionsAndRestorationIdentifier(location, JSON.stringify(options), Turbo.navigator.restorationIdentifier)
      } else {
        // Propose the visit
        TurboSession.visitProposedToLocation(location.toString(), JSON.stringify(options))
      }
    }

    visitStarted(visit) {
      TurboSession.visitStarted(visit.identifier, visit.hasCachedSnapshot(), visit.isPageRefresh || false, visit.location.toString())
      this.currentVisit = visit
      this.issueRequestForVisitWithIdentifier(visit.identifier)
      this.changeHistoryForVisitWithIdentifier(visit.identifier)
      this.loadCachedSnapshotForVisitWithIdentifier(visit.identifier)
    }

    visitRequestStarted(visit) {
      TurboSession.visitRequestStarted(visit.identifier)
    }

    visitRequestCompleted(visit) {
      TurboSession.visitRequestCompleted(visit.identifier)
      this.loadResponseForVisitWithIdentifier(visit.identifier)
    }

    async visitRequestFailedWithStatusCode(visit, statusCode) {
      // Turbo does not permit cross-origin fetch redirect attempts and
      // they'll lead to a visit request failure. Attempt to see if the
      // visit request failure was due to a cross-origin redirect.
      const redirect = await this.fetchFailedRequestCrossOriginRedirect(visit, statusCode)
      const location = visit.location.toString()

      if (redirect != null) {
        TurboSession.visitProposedToCrossOriginRedirect(location, redirect.toString(), visit.identifier)
      } else {
        TurboSession.visitRequestFailedWithStatusCode(location, visit.identifier, visit.hasCachedSnapshot(), statusCode)
      }
    }

    visitRequestFinished(visit) {
      TurboSession.visitRequestFinished(visit.identifier)
    }

    visitRendered(visit) {
      this.afterNextRepaint(function () {
        TurboSession.visitRendered(visit.identifier)
      })
    }

    visitCompleted(visit) {
      this.afterNextRepaint(function () {
        TurboSession.visitCompleted(visit.identifier, visit.restorationIdentifier)
      })
    }

    formSubmissionStarted(formSubmission) {
      TurboSession.formSubmissionStarted(formSubmission.location.toString())
    }

    formSubmissionFinished(formSubmission) {
      TurboSession.formSubmissionFinished(formSubmission.location.toString())
    }

    pageInvalidated() {
      TurboSession.pageInvalidated()
    }

    // Private

    async fetchFailedRequestCrossOriginRedirect(visit, statusCode) {
      // Non-HTTP status codes are sent by Turbo for network
      // failures, including cross-origin fetch redirect attempts.
      if (statusCode <= 0) {
        try {
          const response = await fetch(visit.location, {redirect: "follow"})
          if (response.url != null && response.url.origin != visit.location.origin) {
            return response.url
          }
        } catch {
        }
      }

      return null
    }

    afterNextRepaint(callback) {
      if (document.hidden) {
        callback()
      } else {
        requestAnimationFrame(function () {
          requestAnimationFrame(callback)
        })
      }
    }
  }

  // Setup and register adapter

  window.turboNative = new TurboNative()

  const setup = function () {
    window.turboNative.registerAdapter()
    window.turboNative.pageLoaded()

    document.removeEventListener("turbo:load", setup)
  }

  const setupOnLoad = () => {
    document.addEventListener("turbo:load", setup)

    // document.addEventListener('inertia:start', (event) => {
    //   console.log(event)
    //   console.log(`Starting a visit to ${event.detail.visit.url}`)
    // })

    // document.addEventListener('inertia:before', (event) => {
    //   console.log(event)
    //   console.log(`About to make a visit to ${event.detail.visit.url}`)
    // })

    // document.addEventListener('inertia:success', (event) => {
    //   console.log(event)
    //   console.log(`Successfully made a visit to ${event.detail}`)
    // })

    // document.addEventListener('inertia:error', (event) => {
    //   console.log(`Some error ${event.detail}`)
    // })

    // setTimeout(() => {
    //   if (!window.Turbo) {
    //     TurboSession.turboIsReady(false)
    //     window.turboNative.pageLoadFailed()
    //   }
    // }, TURBO_LOAD_TIMEOUT)
  }

  if (window.Turbo) {
    setup()
  } else {
    setupOnLoad()
  }
})()