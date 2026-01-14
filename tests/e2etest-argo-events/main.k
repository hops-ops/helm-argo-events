import datetime
import math
import models.io.upbound.dev.meta.v1alpha1 as metav1alpha1
import models.k8s.apimachinery.pkg.apis.meta.v1 as metav1

# ==============================================================================
# E2E Test for ArgoEvents XRD (Kubernetes-only)
# ==============================================================================

_now = str(int(math.floor(datetime.ticks())))
_test_name = "e2e-argo-events-" + _now

_items = [
    metav1alpha1.E2ETest {
        metadata.name = "argo-events-helm"
        spec = {
            crossplane = {
                version = "2.0.2-up.5"
                autoUpgrade.channel = "None"
            }
            skipDelete = False

            extraResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "ProviderConfig"
                    metadata = {
                        name = "default"
                        namespace = "default"
                    }
                    spec = {
                        credentials = {
                            source = "InjectedIdentity"
                        }
                    }
                }
            ]

            manifests = [
                {
                    apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                    kind = "ArgoEvents"
                    metadata = {
                        name = _test_name
                        namespace = "default"
                    }
                    spec = {
                        clusterName = _test_name
                        labels = {
                            "hops.ops.com.ai/e2etest" = "true"
                            "hops.ops.com.ai/test-run" = _now
                        }
                        providerConfigRef = {
                            name = "default"
                            kind = "ProviderConfig"
                        }
                        values = {
                            # Minimal resources for E2E test
                            controller = {
                                resources = {
                                    requests = {
                                        cpu = "10m"
                                        memory = "64Mi"
                                    }
                                }
                            }
                        }
                    }
                }
            ]
        }
    }
]
items = _items
