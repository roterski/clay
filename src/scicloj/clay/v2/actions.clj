(ns scicloj.clay.v2.actions
  (:require
   [scicloj.clay.v2.eval :as eval]
   [scicloj.clay.v2.path :as path]
   [scicloj.clay.v2.server :as server]
   [scicloj.clay.v2.show :as show]
   [scicloj.clay.v2.quarto :as quarto]))

(defn show-doc!
  ([path]
   (show-doc! path nil))
  ([path {:keys [title toc? custom-message]
          :as options}]
   (show/show-message!
    (or custom-message
        [:div
         [:p "showing document for "
          [:code (path/path->filename path)]]
         [:div.loader]]))
   (let [doc (eval/gen-doc path options)]
     (-> doc
         (show/show-items!
          {:title title
           :toc? toc?})))
   :ok))

(defn show-doc-and-write-html!
  [path options]
  (-> options
      (assoc :custom-message [:div
                              [:p "showing document for "
                               [:code (path/path->filename path)]]
                              [:p "and then writing as html file"]
                              [:div.loader]]
             :path path)
      (->> (show-doc! path)))
  (Thread/sleep 1000)
  (show/write-html!))

(defn render-quarto!
  [path {:keys [title]
         :as options}]
  (show/show-message!
   [:div
    [:p "generating Quarto document for "
     [:code (path/path->filename path)]]
    [:div.loader]])
  (-> options
      (assoc
       :title (or title path)
       :path path)
      (->> (eval/gen-doc path))
      quarto/render-quarto!))

(defn write-quarto!
  [path {:keys [title]
         :as options}]
  (-> options
      (assoc
       :title (or title path)
       :path path)
      (->> (eval/gen-doc path))
      quarto/write-quarto!))
