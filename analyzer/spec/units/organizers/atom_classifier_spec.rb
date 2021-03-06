require 'spec_helper'

module VersatileDiamond
  module Organizers

    describe AtomClassifier, type: :organizer, use: :atom_properties do
      subject { described_class.new }

      describe '#analyze' do
        before do
          [
            dept_activated_bridge,
            dept_extra_activated_bridge,
            dept_hydrogenated_bridge,
            dept_extra_hydrogenated_bridge,
            dept_right_hydrogenated_bridge,
            dept_dimer_base,
            dept_activated_dimer,
            dept_methyl_on_incoherent_bridge,
            dept_high_bridge,
          ].each do |spec|
            subject.analyze(spec)
          end
        end

        describe '#props' do
          it { expect(subject.props.size).to eq(32) }
          it { expect(subject.props).to include(
              high_cm,
              bridge_ct, ab_ct, eab_ct, aib_ct, hb_ct, ehb_ct, hib_ct, ahb_ct,
              bridge_cr, ab_cr,
              ib_cr, dimer_cr, ad_cr
            ) }
        end

        describe '#organize_properties!' do
          def find(prop)
            subject.props[subject.index(prop)]
          end

          before(:each) { subject.organize_properties! }

          describe '#smallests' do
            it { expect(find(high_cm).smallests).to be_nil }

            it { expect(find(bridge_ct).smallests).to be_nil }
            it { expect(find(ab_ct).smallests.to_a).to eq([bridge_ct]) }
            it { expect(find(hb_ct).smallests.to_a).to eq([bridge_ct]) }
            it { expect(find(eab_ct).smallests.to_a).to eq([ab_ct]) }
            it { expect(find(aib_ct).smallests.to_a).to eq([ab_ct]) }
            it { expect(find(ehb_ct).smallests.to_a).to eq([hib_ct]) }
            it { expect(find(hib_ct).smallests.size).to eq(2) }
            it { expect(find(ahb_ct).smallests.to_a).
              to match_array([hb_ct, aib_ct]) }

            it { expect(find(bridge_cr).smallests.to_a).to eq([bridge_ct]) }
            it { expect(find(ib_cr).smallests.to_a).to eq([bridge_cr]) }
            it { expect(find(ab_cr).smallests.to_a).
              to match_array([ab_ct, bridge_cr]) }
            it { expect(find(hb_cr).smallests.to_a).
              to match_array([hb_ct, ib_cr]) }

            it { expect(find(dimer_cr).smallests.to_a).to eq([bridge_ct]) }
            it { expect(find(ad_cr).smallests.to_a).
              to match_array([ab_ct, dimer_cr]) }
          end

          describe '#sames' do
            it { expect(find(bridge_ct).sames).to be_nil }
            it { expect(find(bridge_cr).sames).to be_nil }
            it { expect(find(dimer_cr).sames).to be_nil }
            it { expect(find(ab_ct).sames).to be_nil }

            it { expect(find(aib_ct).sames.size).to eq(1) }
            it { expect(find(ahb_ct).sames.size).to eq(2) }
            it { expect(find(ad_cr).sames.size).to eq(1) }

            it { expect(find(eab_ct).sames.to_a).to eq([aib_ct]) }
            it { expect(find(ab_cr).sames.to_a).to eq([ib_cr]) }
          end

          describe '#general_transitive_matrix' do
            it { expect(subject.general_transitive_matrix.to_a).to eq([
                  [true, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [true, true, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [true, true, true, true, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, true, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, true, true, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, false, false, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, false, false, false, true, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, false, false, false, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, true, true, false, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, false, false, false, true, true, true, true, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [true, true, false, false, false, false, true, false, true, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, false, false, false, true, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, false, false, false, true, false, false, false, false, false, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, true, false, false, true, false, false, false, false, false, false, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, false, true, false, true, false, false, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false],
                  [false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, false, false, false, false, false, false, false, false],
                  [false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false],
                  [false, false, false, true, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, false, false, false, false, false, false, false],
                  [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false],
                  [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, false, false, false, false, false],
                  [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, false, true, false, false, false, false],
                  [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, false, false, false],
                  [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, true, false, false],
                  [false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, false],
                  [true, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true]
                ]) }
          end

          describe '#specification' do
            it { expect(subject.specification).to eq([12, 12, 2, 10, 10, 5, 11, 11, 11, 11, 10, 11, 12, 14, 14, 15, 17, 17, 19, 19, 21, 21, 22, 23, 23, 25, 27, 27, 29, 29, 30, 31, 32]) }
          end

          describe '#actives_to_deactives' do
            it { expect(subject.actives_to_deactives).to eq([0, 1, 0, 6, 7, 3, 6, 7, 8, 9, 8, 11, 12, 13, 14, 13, 16, 17, 16, 17, 18, 19, 20, 23, 24, 24, 26, 27, 26, 27, 28, 31, 32]) }
          end

          describe '#deactives_to_actives' do
            it { expect(subject.deactives_to_actives).to eq([2, 2, 2, 5, 5, 5, 3, 4, 10, 10, 10, 11, 12, 15, 15, 15, 18, 19, 20, 21, 22, 22, 22, 25, 25, 25, 28, 29, 30, 30, 30, 31, 32]) }
          end

          describe '#is?' do
            it { expect(subject.is?(hb_cr, ib_cr)).to be_truthy }
            it { expect(subject.is?(ib_cr, hb_cr)).to be_falsey }

            it { expect(subject.is?(hb_cr, bridge_ct)).to be_truthy }
            it { expect(subject.is?(bridge_ct, hb_cr)).to be_falsey }

            it { expect(subject.is?(eab_ct, ab_ct)).to be_truthy }
            it { expect(subject.is?(ab_ct, eab_ct)).to be_falsey }
            it { expect(subject.is?(eab_ct, aib_ct)).to be_truthy }
            it { expect(subject.is?(aib_ct, eab_ct)).to be_falsey }
            it { expect(subject.is?(eab_ct, bridge_ct)).to be_truthy }
            it { expect(subject.is?(bridge_ct, eab_ct)).to be_falsey }
          end

          describe 'generate graph' do
            let(:filename) { 'classifier_spec' }
            let(:image_name) { "#{filename}.png" }
            let(:graph) do
              Generators::ClassifierResultGraph.new(subject, filename)
            end
            it { expect { graph.generate }.not_to raise_error }

            describe 'image is not empty' do
              before { graph.generate }
              it { expect(File.size(image_name) > 200).to be_truthy }
            end

            # Comment line below for draw a graph which could help to inspect
            # dependencies between atom properties
            after { File.unlink(image_name) }
          end
        end

        describe '#classify' do
          describe 'termination spec' do
            shared_examples_for :termination_classify do
              let(:result) { subject.classify(term) }
              it { expect(result).to eq(hash) }
            end

            it_behaves_like :termination_classify do
              let(:term) { dept_active_bond }
              let(:hash) do
                {
                  10 => ['H*C%d<', 1],
                  15 => ['-*C%d<', 1],
                  18 => ['*C~%d', 1],
                  19 => ['*C:i~%d', 1],
                  2 => ['^*C%d<', 1],
                  20 => ['**C~%d', 2],
                  21 => ['**C:i~%d', 2],
                  22 => ['***C~%d', 3],
                  25 => ['_~*C%d<', 1],
                  28 => ['*C=%d', 1],
                  29 => ['*C:i=%d', 1],
                  30 => ['**C=%d', 2],
                  3 => ['*C%d<', 1],
                  4 => ['*C:i%d<', 1],
                  5 => ['**C%d<', 2],
                }
              end
            end

            it_behaves_like :termination_classify do
              let(:term) { dept_adsorbed_h }
              let(:hash) do
                {
                  0 => ['^C%d<', 1],
                  1 => ['^C:i%d<', 1],
                  10 => ['H*C%d<', 1],
                  11 => ['HHC%d<', 2],
                  12 => ['^HC%d<', 1],
                  13 => ['-C%d<', 1],
                  14 => ['-C:i%d<', 1],
                  16 => ['C~%d', 3],
                  17 => ['C:i~%d', 3],
                  18 => ['*C~%d', 2],
                  19 => ['*C:i~%d', 2],
                  20 => ['**C~%d', 1],
                  21 => ['**C:i~%d', 1],
                  23 => ['_~C:i%d<', 1],
                  24 => ['_~C%d<', 1],
                  26 => ['C=%d', 2],
                  27 => ['C:i=%d', 2],
                  28 => ['*C=%d', 1],
                  29 => ['*C:i=%d', 1],
                  4 => ['*C:i%d<', 1],
                  3 => ['*C%d<', 1],
                  6 => ['C%d<', 2],
                  7 => ['C:i%d<', 2],
                  8 => ['HC%d<', 2],
                  9 => ['HC:i%d<', 2],
                }
              end
            end

            it_behaves_like :termination_classify do
              let(:term) { dept_adsorbed_cl }
              let(:hash) { {} }
            end
          end

          describe 'not termination spec' do
            shared_examples_for :specific_classify do
              it { expect(subject.classify(spec)).to eq(hash) }
            end

            it_behaves_like :specific_classify do
              let(:spec) { dept_activated_bridge }
              let(:hash) do
                {
                  0 => ['^C%d<', 2],
                  3 => ['*C%d<', 1],
                }
              end
            end

            it_behaves_like :specific_classify do
              let(:spec) { dept_extra_activated_bridge }
              let(:hash) do
                {
                  0 => ['^C%d<', 2],
                  5 => ['**C%d<', 1],
                }
              end
            end

            it_behaves_like :specific_classify do
              let(:spec) { dept_hydrogenated_bridge }
              let(:hash) do
                {
                  0 => ['^C%d<', 2],
                  8 => ['HC%d<', 1],
                }
              end
            end

            it_behaves_like :specific_classify do
              let(:spec) { dept_extra_hydrogenated_bridge }
              let(:hash) do
                {
                  0 => ['^C%d<', 2],
                  11 => ['HHC%d<', 1],
                }
              end
            end

            it_behaves_like :specific_classify do
              let(:spec) { dept_right_hydrogenated_bridge }
              let(:hash) do
                {
                  0 => ['^C%d<', 1],
                  6 => ['C%d<', 1],
                  12 => ['^HC%d<', 1],
                }
              end
            end

            it_behaves_like :specific_classify do
              let(:spec) { dept_dimer_base }
              let(:hash) do
                {
                  0 => ['^C%d<', 4],
                  13 => ['-C%d<', 2],
                }
              end
            end

            it_behaves_like :specific_classify do
              let(:spec) { dept_activated_dimer }
              let(:hash) do
                {
                  0 => ['^C%d<', 4],
                  13 => ['-C%d<', 1],
                  15 => ['-*C%d<', 1],
                }
              end
            end

            it_behaves_like :specific_classify do
              let(:spec) { dept_methyl_on_incoherent_bridge }
              let(:hash) do
                {
                  0 => ['^C%d<', 2],
                  16 => ['C~%d', 1],
                  23 => ['_~C:i%d<', 1],
                }
              end
            end

            it_behaves_like :specific_classify do
              let(:spec) { dept_high_bridge }
              let(:hash) do
                {
                  0 => ['^C%d<', 2],
                  26 => ['C=%d', 1],
                  31 => ['_=C%d<', 1],
                }
              end
            end

            describe 'organize species dependencies' do
              shared_examples_for :organized_specific_classify do
                let(:result) { subject.classify(target_spec) }
                before { organize(all_species) }
                it { expect(result).to eq(hash) }
              end

              it_behaves_like :organized_specific_classify do
                let(:target_spec) { dept_activated_bridge }
                let(:all_species) { [dept_activated_bridge] }
                let(:hash) do
                  { 3 => ['*C%d<', 1] }
                end
              end

              it_behaves_like :organized_specific_classify do
                let(:target_spec) { dept_dimer_base }
                let(:all_species) { [dept_bridge_base, dept_dimer_base] }
                let(:hash) do
                  { 13 => ['-C%d<', 2] }
                end
              end

              it_behaves_like :organized_specific_classify do
                let(:target_spec) { dept_activated_methyl_on_incoherent_bridge }
                let(:all_species) do
                  [
                    dept_activated_bridge,
                    dept_activated_dimer,
                    dept_activated_methyl_on_incoherent_bridge
                  ]
                end
                let(:hash) do
                  {
                    18 => ['*C~%d', 1],
                    23 => ['_~C:i%d<', 1]
                  }
                end
              end
            end
          end
        end

        describe '#index' do
          it { expect(subject.index(dept_bridge, bridge.atom(:cr))).to eq(0) }
          it { expect(subject.index(bridge_cr)).to eq(0) }

          let(:atom) { activated_bridge.atom(:ct) }
          it { expect(subject.index(dept_activated_bridge, atom)).to eq(3) }
          it { expect(subject.index(ab_ct)).to eq(3) }
        end

        describe '#all_types_num' do
          it { expect(subject.all_types_num).to eq(32) }
        end

        describe '#notrelevant_types_num' do
          it { expect(subject.notrelevant_types_num).to eq(21) }
        end

        describe '#has_relevants?' do
          it { expect(subject.has_relevants?(4)).to be_truthy }
          it { expect(subject.has_relevants?(14)).to be_truthy }

          it { expect(subject.has_relevants?(0)).to be_falsey }
          it { expect(subject.has_relevants?(2)).to be_falsey }
          it { expect(subject.has_relevants?(6)).to be_falsey }
          it { expect(subject.has_relevants?(8)).to be_falsey }
          it { expect(subject.has_relevants?(10)).to be_falsey }
          it { expect(subject.has_relevants?(12)).to be_falsey }
          it { expect(subject.has_relevants?(16)).to be_falsey }
          it { expect(subject.has_relevants?(18)).to be_falsey }
          it { expect(subject.has_relevants?(20)).to be_falsey }
          it { expect(subject.has_relevants?(22)).to be_falsey }
          it { expect(subject.has_relevants?(24)).to be_falsey }
          it { expect(subject.has_relevants?(26)).to be_falsey }
          it { expect(subject.has_relevants?(28)).to be_falsey }
          it { expect(subject.has_relevants?(30)).to be_falsey }
        end
      end
    end

  end
end
