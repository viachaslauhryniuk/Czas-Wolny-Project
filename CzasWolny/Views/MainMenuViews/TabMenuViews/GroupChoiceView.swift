

import SwiftUI
import SwiftUIWheelPicker
struct GroupChoiceView: View {
    @EnvironmentObject var vm: ContentViewModel
    var body: some View {
       
            VStack(spacing: 20) {
                Text("Aby zobaczyć zawartość tej sekcji, wybierz swoją grupę")
                    .font(.custom("FallingSkyBd", size: 30))
                    .foregroundStyle(Color("BlueAccent"))
                    .padding(12)
                    .padding(.vertical,12)
                    .multilineTextAlignment(.center)
                Picker("Year", selection: $vm.selectedYear) {
                    ForEach(vm.years, id: \.self) {
                        Text("Rok \($0)").tag($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                if vm.selectedYear != 3 {
                    Text("Grupa: ")
                        .font(Font.custom("FallingSkyBd", size: 18))
                        .foregroundStyle(Color.black)
                    GroupPicker(groups: vm.groups[vm.selectedYear - 1], selection: $vm.selectGroup)
                        }
                else {
                    SpecialityPicker(specialities: vm.specialities, selection: $vm.selectedSpeciality)
                    Text("Grupa: ")
                        .font(Font.custom("FallingSkyBd", size: 18))
                        .foregroundStyle(Color.black)
                    GroupPicker(groups: vm.groups[vm.selectedYear - 1], selection: $vm.selectGroup)
                }  
                SelectButton(vm: _vm)
            }
            
            .padding()
        }
    }


struct GroupPicker: View {
    let groups: [Int]
    @Binding var selection: Int

    var body: some View {
        Picker("Group", selection: $selection) {
            ForEach(groups, id: \.self) {
                Text("\($0)").tag($0)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct SpecialityPicker: View {
    let specialities: [String]
    @Binding var selection: String

    var body: some View {
        Picker("Speciality", selection: $selection) {
            ForEach(specialities, id: \.self) {
                Text($0).tag($0)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct SelectButton: View {
    @EnvironmentObject var vm : ContentViewModel

    var body: some View {
        Button(action: {
            vm.updateSelectedGroup()
        }) {
            Text("Wybierz grupę")
            .font(.custom("FallingSkyBlk", size: 27))
            .foregroundStyle(Color.white)
    }
    .frame(width: 300, height: 60)
    .background(Color("BlueAccent"))
    .clipShape(.rect(cornerRadius: 15))
    .padding(.bottom,5)
    
    }
    
}
extension ContentViewModel {
    func updateSelectedGroup() {
        if selectedYear != 3 {
            selectedGroup = "\(selectedYear*2)I \(selectGroup)"
        } else {
            selectedGroup = "\(selectedYear*2)I \(selectedSpeciality) \(selectGroup)"
        }
    }
}



#Preview {
    GroupChoiceView()
        .environmentObject(ContentViewModel())
}
