function Supp = findSparseModeWeighted( J, P, singleton, model, weights, epsilon )
% Finds a mode that contains as many reactions from J and as few from P.
% Returns its support, or [] if no reaction from J can get flux above epsilon.
% Based on: `The FASTCORE algorithm for context-specific metabolic network reconstruction.
% Input C is the core set, and output A is the reconstruction, Vlassis et
% al., 2013, PLoS Comp Biol.`
%
% USAGE:
%
%    Supp = findSparseMode( J, P, singleton, model, epsilon )
%
% INPUTS:
%    J:           Indicies of irreversible reactions
%    P:           Reactions
%    singleton:   Takes only first instance from J, else takes whole J
%    model:       Model structure
%    epsilon:     Parameter (default: 1e-4; see Vlassis et al for more details)
%
% OUTPUT:
%    Supp:        Support or [] if no reaction from J can get flux above epsilon
%
% .. Author: - Ines Thiele, Dec 2013

Supp = [];
if isempty( J )
  return;
end

if singleton
  V = LP7( J(1), model, epsilon );
else
  V = LP7( J, model, epsilon );
end

K = intersect( J, find(V >= 0.99*epsilon) );

if isempty( K )
  return;
end

%V = LP9( K, P, model, epsilon );
V = LP9weighted( weights, K, P, model, epsilon );


Supp = find( abs(V) >= 0.99*epsilon );
