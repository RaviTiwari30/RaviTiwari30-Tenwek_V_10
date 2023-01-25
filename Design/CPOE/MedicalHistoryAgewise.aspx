<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MedicalHistoryAgewise.aspx.cs" Inherits="Design_CPOE_MedicalHistoryAgewise" MasterPageFile="~/DefaultHome.master" %>

<asp:Content ID="Conent1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            bindBodySystem();
        });

        function bindBodySystem() {
            serverCall('MedicalHistoryAgewise.aspx/ReviewSystemMaster', {}, function (response) {
                responseData = JSON.parse(response);
                bindMedicalHistory(responseData);
            });
        }
        function bindMedicalHistory(data) {
            for (var i = 0; i < data.length; i++) {

                var j = $('#tblMedicalHistory tbody tr').length + 1;
                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="width:120px">' + parseInt(i + 1) + '</td>';
                row += '<td class="GridViewLabItemStyle" style="width:120px" id="tdBodySystemName">' + data[i].BodySystemName + '</td>';
                row += '<td style="width:120px" ><img id="imgEdit" src="../../Images/ButtonAdd.png" onclick="Edit(this);" /></td>';
                row += '<td class="GridViewLabItemStyle" style="width:120px;display:none;" id="tdBodySystemID">' + data[i].BodySystemID + '</td>';
                row += '</tr>';
                $('#tblMedicalHistory tbody').append(row);
            }
        }

        function Edit(rowid) {
            var row = $(rowid).closest('tr');
            var sid = row.find('#tdBodySystemID').text();
            bindMedicalHistoryAgeAndGenderWise(sid);
            $('#divAgeandGenderWise').show();
        }

        function bindMedicalHistoryAgeAndGenderWise(sid) {
            $('#spnBodysystemid').text(sid);
            var data={
                sid:sid,
                Gender:$("input[name='gender']:checked").val()
            }
            serverCall('MedicalHistoryAgewise.aspx/bindMedicalHistoryAgeAndGenderWise', data, function (response) {
                var responseData = JSON.parse(response);
                
                    getAgeAndGender(responseData);
                
                
            });
        }
        function getAgeAndGender(data) {

            $('#tblMedicalHistroyageWise tbody').empty();
            if (data.length > 0) {
                for (var i = 0; i < data.length; i++) {
                    var j = $('#tblMedicalHistroyageWise tbody tr').length + 1;
                    var row = '<tr>';
                    row += '<td class="GridViewLabItemStyle">' + parseInt(i + 1) + '</td>';
                    row += '<td class="GridViewLabItemStyle"><span id="lblFromAge" >' + data[i].FromAge + '</span></td>';
                    row += '<td class="GridViewLabItemStyle"><input type="text" id="txtToAgeyears"  value=' + data[i].ToAgeYears + ' max-value="180" onlynumber="3" onkeyup="CalculateAgeOnDays(this)"></td>';
                    row += '<td class="GridViewLabItemStyle"><input type="text" id="txtToAge" value=' + data[i].ToAge + '></td>';
                    row += '<td id="imgAdd" class="GridViewLabItemStyle"><img src="../../Images/ButtonAdd.png" onclick="AddDetails(this);" /></td> ';
                    row += '<td id="imgRmv" class="GridViewLabItemStyle"><img src="../../Images/Delete.gif" onclick="RmvDetail(this);" /></td>';
                    row += '<td class="GridViewLabItemStyle"><span id="spnBodysystemid"></span></td>';
                    row += '</tr>';
                    $('#tblMedicalHistroyageWise tbody').append(row);
                }
            }
            else {
                AddnewRow('1', '0');
            }

        }
        function AddnewRow(count, frmAgenew) {
            var row = '<tr>';
            row += '<td class="GridViewLabItemStyle" >' + count + '</td>';
            row += '<td class="GridViewLabItemStyle"><span id="lblFromAge" >' + frmAgenew + '</span></td>';
            row += '<td class="GridViewLabItemStyle"><input type="text" id="txtToAgeyears" onkeyup="CalculateAgeOnDays(this)" max-value="180" onlynumber="3"></td>';
            row += '<td class="GridViewLabItemStyle"><input type="text" id="txtToAge"></td>';
            row += '<td id="Td2" class="GridViewLabItemStyle"><img src="../../Images/ButtonAdd.png" onclick="AddDetails(this);" /></td>';
            row += '<td id="Td3" class="GridViewLabItemStyle"><img src="../../Images/Delete.gif" onclick="RmvDetail(this);" /></td>';
            
            row += '</tr>';
            $('#tblMedicalHistroyageWise tbody').append(row);

        }
        function AddDetails(rowid) {

            var row = $(rowid).closest('tr');
            var count = $('#tblMedicalHistroyageWise tr').length;
            var ToAge = $(row).find('#txtToAge').val();
            var frmAge = $(row).find("#lblFromAge").text();
            if (ToAge == "") {
                modelAlert('Please Enter Age');
                $(row).find("#txtToAge").focus();
                return;
            }
            if (ToAge > 58400) {
                modelAlert('Age Cannot Be Greater Than 180 Yrs');
                return;
            }

            var isVisible = $(row).find("#txtToAge").is(':visible');
            if (isVisible == true && (Number(ToAge) < Number(frmAge))) {
                modelAlert('To Age Should be Greater than FromAge');
                return;
            }

            var frmAgenew = $(row).find("#txtToAge").val();
            frmAgenew = Number(frmAgenew) + 1;
            AddnewRow(count, frmAgenew);
        }
        function CalculateAgeOnDays(el) {
            var row = $(el).closest('tr');
            if ($(row).find('#txtToAgeyears').val() != "") {
                var Days = ($(row).find('#txtToAgeyears').val() * 365);
                $(row).find("#txtToAge").val(Days);
            }
            else
                $(row).find("#txtToAge").val('');
        }

        function RmvDetail(rowid) {
           
            $('#tblMedicalHistroyageWise tr:last').remove();
        }
        function SaveAgewise()
        {
            $getMedicalHistoryAgeAndGender(function (ageandgenderdetails) {
                serverCall('MedicalHistoryAgewise.aspx/saveMedicalhistoryageandgender', ageandgenderdetails, function (response) {
                    
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        modelAlert(responseData.response);
                    }
                    else {
                        modelAlert(responseData.response);
                    }
                });

            });
        }
        
        function $getMedicalHistoryAgeAndGender(callback)
        {
            data = [];
            $('#tblMedicalHistroyageWise tbody').each(function (index, rowid) {
                var row = $(rowid)
                data.push({
                    genderType: $("input[name='gender']:checked").val(),
                    ageFrom: Number($(row).find('#lblFromAge').text()),
                    ageTo:  $(row).find('#txtToAge').val(),
                    ageToYear: $(row).find('#txtToAgeyears').val(),
                    bodysystemID:Number($('#spnBodysystemid').text())
                });

            });
            callback({ data: data });
        }

        function bindMedicalHistoryAgewise(el) {
           var  Gender= $("input[name='gender']:checked").val();
           if (Gender == 'B') {
               modelAlert('In case of Both, Default Male ranges are loaded \r\n You can save these ranges for Both Male and female also !', function () {
                   bindMedicalHistoryAgeAndGenderWise($('#spnBodysystemid').text());
               });
           }
           else { bindMedicalHistoryAgeAndGenderWise($('#spnBodysystemid').text()); }
       
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Show Medical History Age And Gender Wise<br />
            </b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Medical History</div>
            <div id="divMedicalHistory">
                <table id="tblMedicalHistory" rules="all" border="1" style="border-collapse: collapse; width: 100%;" class="GridViewStyle" cellspacing="0">
                    <tr id="ItemHeader">
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Sr.NO</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Medical History</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: center">AgeWise</th>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <div id="divAgeandGenderWise" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 664px; height: 239px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divAgeandGenderWise" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Enter Age and Gender <span id="spnBodysystemid" style="display:none"></span></h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-24">
                            <input type="radio" id="rdMale" name="gender" checked="checked" value="M" onclick="bindMedicalHistoryAgewise(this);" />Male
                                    <input type="radio" id="rdFemale" name="gender" value="F" onclick="bindMedicalHistoryAgewise(this);" />Female
                                    <input type="radio" id="rdBoth" name="gender" value="B" onclick="bindMedicalHistoryAgewise(this);" />Both
                        </div>

                    </div>
                    <div class="row Purchaseheader">
                        Enter Age & Gender
                    </div>
                    <div class="row">
                        <div id="div_MedicalHistory_popup" style="max-height: 600px; width: 100%; overflow-y: auto; overflow-x: auto; text-align: center;">
                            <table id="tblMedicalHistroyageWise"  class="FixedHeader" rules="all" border="1" style="border-collapse: collapse; width: 100%;"  cellspacing="0">
                                <thead>
                                <tr>
                                    <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Sr.NO</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="text-align: center">FromAge(Days)</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="text-align: center">ToAge(Years)</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="text-align: center">ToAge(Days)</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="text-align: center" >Add</th>
			                        <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Remove</th>	
                                </tr>
                                </thead>
                                 <tbody></tbody>
                            </table>     
                        </div>
                </div>

                </div>
                <div class="modal-footer">
                    <div class="row" style="text-align:center;">
                        <div class="col-md-24">
                            <button type="button" id="btnSave" value="Save" onclick="SaveAgewise();">Save</button>
                            </div>
                        </div>
                        </div>
            </div>
        </div>

    </div>


</asp:Content>
