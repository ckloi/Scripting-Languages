library(R6)

bintree <- R6Class(
  "bintree",
  private = list(
    tree = c(NA,NA,NA),

    modifyMatrix =  function (row, col, value) {
      newIndex <- nrow(private$tree) + 1
      private$tree[row, col] <- newIndex
      # Wont this always trigger? newIndex is nrow(private$tree) + 1
      if (newIndex > nrow(private$tree)){
        private$tree <- rbind(private$tree, c(value, NA, NA))
      }
    }
  )
  ,

  public = list(
    initialize = function() {

    },


    push = function(value,row=1) {
      # check whether head is NA
      if (is.na(private$tree[1])) {
        # first case : new tree -> one row with NA NA NA
        # second case : empty tree with all unused rows
        # if everything and head is delete, then we have a empty matrix with n rows,
        # so we have to reset it to one row before turning vector to matrix

        # if dim is not null, then it is second case, since vector's dim is null
        if (!is.null(dim(private$tree))) {
          private$tree <- private$tree[1, ]
        }
        # turn vector to 1 x 3 matrix
        dim(private$tree) <- c(1, 3)
        private$tree[1, 1] <- value
        return(self)
      }

      # if value is less than or equal to the first index
      if (value <= private$tree[row, 1]) {
        # if left child is na , set it
        if (is.na(private$tree[row, 2])) {
          private$modifyMatrix(row, 2, value)
        } else{
          # if left child is not na, then find the appropriate row recusively
          self$push(value, private$tree[row, 2])
        }
        # if value is greater than first index, the similar approach as above
      } else if (value > private$tree[row, 1]) {
        if (is.na(private$tree[row, 3])) {
          private$modifyMatrix(row, 3, value)
        } else{
          self$push(value, private$tree[row, 3])
        }
      }
      return(self)
    },
  #
  #
    pop = function(row=1) {
        # Check if head is the leftmost node
        if(is.na(private$tree[1,2])){
            x <- private$tree[row,1]
            right <- private$tree[row,3]
            private$tree[row,] <- private$tree[right,]
            return (x)
        }

        # Look ahead one node to the left. If that node's left pointer is NA, pop that
        #   node (change left pointer of current node to right node of child, which
        #   will either be an index or NA)
        left <- private$tree[row,2]
        if(is.na(private$tree[left,2])){
            private$tree[row,2] <- private$tree[left,3]
            return (private$tree[left,1])
        }
        # If not at leftmost node, recurse until you are
        return(self$pop(left))
    },

    print = function(row=1) {
      # Print left subtree
      left <- private$tree[row, 2]
      if (!is.na(left)) {
        self$print(left)
      }

      if (!is.na(private$tree[1,1])){
        # Print your value
        cat(private$tree[row, 1], " ")
      }

      # Print right subtree
      right <- private$tree[row, 3]
      if (!is.na(right)) {
        self$print(right)
      }

      if (row == 1){
        cat('\n')
      }

    }
  )
)

newbintree <- function(){
  bintree$new()
}

push <- function(obj,value){
  obj$push(value)
}

pop <- function(obj){
  obj$pop()
}
