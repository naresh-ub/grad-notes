from manim import *

class FollowingGraphCamera(MovingCameraScene):
    def __init__(self, graph_function, **kwargs):
        super().__init__(**kwargs)
        self.graph_function = graph_function

    def construct(self):
        self.camera.frame.save_state()

        # Create the axes and the curve using the input function
        ax = Axes(x_range=[-10, 10], y_range=[-10, 10])
        graph = ax.plot(self.graph_function, color=BLUE)

        # Create dots based on the graph
        moving_dot = Dot(ax.i2gp(graph.t_min, graph), color=ORANGE)
        dot_1 = Dot(ax.i2gp(graph.t_min, graph))
        dot_2 = Dot(ax.i2gp(graph.t_max, graph))

        self.add(ax, graph, dot_1, dot_2, moving_dot)
        self.play(self.camera.frame.animate.scale(0.5).move_to(moving_dot))

        def update_curve(mob):
            mob.move_to(moving_dot.get_center())

        self.camera.frame.add_updater(update_curve)
        self.play(MoveAlongPath(moving_dot, graph, rate_func=linear))
        self.camera.frame.remove_updater(update_curve)

        self.play(Restore(self.camera.frame))
        self.wait(3)