---
layout: default
title: Syntax of Process Hitting (.ph) files
category_title: Documentation
---

A Process Hitting source file has a filename ending with `.ph` and has the following structure:

<pre><code><a href="#header">[headers]</a><br />
<a href="#main">&lt;body&gt;</a><br />
<a href="#footer">[footers]</a>
</code></pre>

Comments are enclosed by `(*` and `*)` and can be nested.

You can find full examples in the [Model repository]({{ site.baseurl }}/#models).

#### Instructions

##### <a name="header"></a>Header
<dl>
<dt><code>directive default_rate <a href="#t_float"
style="font-style:italic;">Float</a></code>|<code>Inf</code></dt>
<dd>Sets the default rate of actions to the given float value, or to infinity (<code>Inf</code>)
(infinity by default).</dd>
<dt><code>directive stochasticity_absorption <a href="#t_int"
style="font-style:italic;">Int</a></code></dt>
<dd>Sets the default stochasticity absorption factor of actions (1 by default).</dd>
</dl>

##### <a name="main"></a>Body
<dl>
<dt><code>process <a href="#t_process" style="font-style:italic;">process</a></code></dt>
<dd>
<code>process a l </code> defines the sort <code>a</code> as having <code>l+1</code><code> processes
ranging from </code><code>a 0</code> to <code>a l</code>.</dd>
<dt><code><a href="#t_process" style="font-style:italic;">process</a> -&gt; <a href="#t_process"
style="font-style:italic;">process</a> <a href="#t_int" style="font-style:italic;">Int</a> </code>
[<code>@</code> (<code>Inf</code>|<code><a href="#t_float"
style="font-style:italic;">Float</a></code> [<code>~<a href="#t_int"
style="font-style:italic;">Int</a></code>])]</dt>
<dd>
<code>a i -&gt; b j k @ r ~ sa </code> defines a new action: <code>a i</code> hits <code>b j</code>
to make it bounce to <code>b k</code>, with (optional) rate <code>r</code> and stochasticity
absorption factor <code>sa</code>.
</dd>

<dt><code>COOPERATIVITY([<a href="#t_name" style="font-style:italic;">Name</a>;</code>...<code>]
-&gt; <a href="#t_process" style="font-style:italic;">process</a> <a href="#t_int"
style="font-style:italic;">Int</a>, [[<a href="#t_int" style="font-style:italic;">Int</a>;</code>...<code>];</code>...<code>])</code></dt>
<dd>Creates cooperitivity between specified sorts and processes for the given hit.
Example: the following instruction creates a cooperativity between sorts <code>a</code> and
<code>b</code> to make process <code>c0</code> bounce to <code>c1</code> only if <code>a 1, b
0</code> or <code>a 0, b 1</code> are present:
<code>COOPERATIVITY([a;b] -&gt; c 0 1, [[1;0];[0;1]])</code>
</dd>

<dt><code>COOPERATIVITY(
<span class="syn_opt">[
<a href="#t_name" class="type">Name</a>, ,]</span>
<a href="#t_matching" style="font-style:italic;">state_matching</a>,
<a href="#t_name" style="font-style:italic;">Name</a>,
<a href="#t_int" style="font-style:italic;">Int</a>,
<a href="#t_int" style="font-style:italic;">Int</a>)
</code></dt>
<dd>
Example:<br/>
<code>COOPERATIVITY([a;b] not in [[0;1]] and [c] in [[0]], d, 1, 0)</code></br/>
creates nested cooperative sorts that make <code>d</code> bouncing
from <code>0</code> to <code>1</code> (resp. from <code>1</code> to
<code>0</code>) when the state matches (resp. does not match) the specified
condition.
The optional first argument enforces the name of the cooperative sort that hit
the sort <code>d</code>.
</dd>

<dt><code>GRN([<a href="#t_name" style="font-style:italic;">Name</a> <a href="#t_int"
style="font-style:italic;">Int</a> -&gt; </code>(<code>+</code>|<code>-</code>)<code> <a
href="#t_name" style="font-style:italic;">Name</a>; </code>...])</dt>
<dd>
Defines the actions for the generalised dynamics of the <abbr title="Biological Regulatory
Network">BRN</abbr> specified as a regulation list. A regulation <code>a 1 -&gt; + b</code> is
interpreted as: component <code>a</code> beyond the threshold <code>1</code> activates component
<code>b</code>.
</dd>

<dt><code>KNOCKDOWN(<a href="#t_process" style="font-style:italic;">process</a>)</code></dt>
<dd>Deletes all actions related to the given process.</dd>

<dt><code>RM({<a href="#t_action" style="font-style:italic;">action</a>,
</code>...<code>})</code></dt>
<dd>Deletes the given actions</dd>

</dl>

##### <a name="footer"></a>Footer
<dl>
<dt><code>initial_state <a href="#t_process_list"
style="font-style:italic;">process_list</a></code></dt>
<dd>Replaces the given processes in the initial state. By default, the initial state is the process
of the level 0 of each sorts. See also <a
href="/doc/cli/#opt_initial_state"><code>--initial-state</code> option</a>.</dd>
</dl>

#### Data types
<dl>
<dt><code><a name="t_name"></a>Name</code></dt>
<dd><code>(A..z_)(A..z0..9_')*</code></dd>
<dt><code><a name="t_int"></a>Int</code></dt>
<dd><code>(0..9)+</code></dd>
<dt><code><a name="t_float"></a>Float</code></dt>
<dd><code><a href="#t_int">Int</a>.<a href="#t_int">Int</a>*</code></dd>
<dt><code><a name="t_process"></a>process</code></dt>
<dd><code><a href="#t_name">Name</a> <a href="#t_int">Int</a></code></dd>
<dt><code><a name="t_process_list"></a>process_list</code></dt>
<dd><code><a href="#t_process">process</a>, ..., <a href="#t_process">process</a></code></dd>
<dt><a name="t_action"></a><code>action</code></dt>
<dd><code><a href="#t_process">process</a> -&gt; <a href="#t_process">process</a> <a
href="#t_int">Int</a></code></dd>
<dt><a name="t_matching"></a><code>state_matching</code></dt>
<dd>
	<code>not <a href="#t_matching">state_matching</a></code><br />
	| <code>( <a href="#t_matching">state_matching</a> )</code><br />
	| <code><a href="#t_matching">state_matching</a> and <a href="#t_matching">state_matching</a></code><br />
	| <code><a href="#t_matching">state_matching</a> or <a href="#t_matching">state_matching</a></code><br />
	| <code>[<a href="#t_name">Name</a>;</code>...<code>] in [[<a href="#t_int"
	style="font-style:italic;">Int</a>;</code>...<code>];</code>...<code>]</code>
</dd>
</dl>

