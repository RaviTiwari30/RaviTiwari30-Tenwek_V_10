<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientAllergy.aspx.cs" Inherits="Design_CPOE_PatientAllergy" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     
    
</head>
<body>
     <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
              
    <script type="text/javascript">
        $(document).ready(function () {
            $BindAllergy();
            $BindPatientAllergy();
            Search();
        })

        $BindAllergy = function () {
            serverCall('PatientAllergy.aspx/BindAllergyList', {}, function (response) {
                var $ddlAllergyList = $('#ddlAllergyList');
                var $ddlEdiAllergy = $('#ddlEdiAllergy');
                $ddlAllergyList.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'AllergyName', isSearchAble: true });
                $ddlEdiAllergy.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'AllergyName', isSearchAble: true });
            });
        }

        $BindPatientAllergy = function () {
            var Appid = '<%=Request.QueryString["App_ID"].ToString()%>';
             serverCall('PatientAllergy.aspx/BindPatientAllergy', { Appid: Appid }, function (response) {
                 var responseData = JSON.parse(response);
                 if (responseData.status == true) {
                     // $('#ddlAllergyList Option:selected').text(responseData.response[0]['Allergies']).chosen('destroy').chosen();
                     $('#ddlAllergyList').chosen('destroy').find('option').filter(function () { return this.text == responseData.response }).prop('selected', true);
                     $('#ddlAllergyList').chosen();
                 }

            });
        }

        $AddNewAllergy = function () {

            $('#divNewAllergy').showModel();
            $('#divCreatenewallergy').show();
        }
        $Newallergyname = function (el) {
            $('#btnSave').val('Save');
            $('#divCreatenewallergy').show();
            $('#divEditAllergyName').hide();
            $('#txtAllergy').val('');
        }

        $EditallergyMaster = function (el) {
            $('#divCreatenewallergy').hide();
            $('#divEditAllergyName').show();
        }

        $editAllergylist = function (el) {
            $('#divCreatenewallergy').show();
            $('#btnSave').val('Update');
            var Name = $(el).find('Option:selected').text();
            if (Name != 'Select') {
                $('#txtAllergy').val(Name);
                $('#spnAllergyID').text($(el).find('Option:selected').val());
            }
        }

         $saveNewAllergy = function (AlName) {
             if (AlName.AllergyName.trim() != "") {
                 var data = {
                     Name: AlName.AllergyName,
                     Type: $('#btnSave').val(),
                     ID: $('#spnAllergyID').text()
                 }
                 serverCall('PatientAllergy.aspx/SaveNewAllergy', data, function (response) {
                     responeData = JSON.parse(response);
                     if (responeData.Type == "Save") {
                         modelAlert(responeData.response, function () {
                             $BindAllergy();
                             $('#txtAllergy').val('');
                         });

                     }
                     else if (responeData.Type == "Update") {
                         modelAlert(responeData.response, function () {

                             $BindAllergy();
                         });

                     }
                     else { modelAlert(responeData.response); }
                 });
             }
             else { modelAlert('Plesae Type New Allergy Name'); }
         }
         $SavePatientAllergy = function () {
             if ($('#ddlAllergyList').val() == "0") {
                 modelAlert('Please Select Any Type Of Allergy');
                 return false;
             }
             var data = {
                 PAllergy: $('#ddlAllergyList Option:selected').text().trim(),
                 TID: '<%=Request.QueryString["TID"]%>',
                PID: '<%=Request.QueryString["PID"]%>',
                APPID: '<%=Request.QueryString["App_ID"].ToString()%>',
            }

            serverCall('PatientAllergy.aspx/savePatientAllergy', data, function (response) {

                var responseData = JSON.parse(response);
                if (responseData.status) {
                    
                    modelAlert(responseData.response, function () {
                        Search();
                    });
                }

                else {
                    modelAlert(responseData.response);
                }

            });
        }
    </script>
   
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center">
                <b>Patient  Allergy</b><br />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Allergy
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Allergy</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <select id="ddlAllergyList"></select>
                    </div>

                    <div class="col-md-3">
                        <input type="button" id="btnAllergy" value="New Allergy" onclick="$AddNewAllergy()" />
                    </div>

                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row" style="text-align: center">
                    <div class="col-md-24">
                        <input type="button" id="btnSaveAllergy" value="Save" onclick="$SavePatientAllergy()" />
                    </div>

                 </div>
                 </div>


            <div class="POuter_Box_Inventory">

                <div id="divtableOutput" style="max-height: 500px; overflow-y: auto; overflow-x: auto;">
                    <table id="tblOutput" rules="all" border="1" style="border-collapse: collapse; width: 100%; display: none" class="GridViewStyle">
                        <thead>

                            <tr>

                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">SNO.</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Allergy</th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Remove</th>

                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>


            </div>
             
            <div id="divNewAllergy" class="modal fade ">
                <div class="modal-dialog">
                    <div class="modal-content" style="background-color: white; width: 357px; height: 172px">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="divNewAllergy" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">
                                <input type="radio" id="rdAddNewAllergy" name="Allergy" checked="checked" onclick="$Newallergyname(this)" />New
                            <input type="radio" id="rdEditAllergy" onclick="$EditallergyMaster(this)" name="Allergy" />Edit</h4>
                        </div>
                        <div class="modal-body">
                            <div class="row" id="divEditAllergyName" style="display: none">
                                <div class="col-md-10">
                                    <label class="pull-left">Allergy</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-14">
                                    <select id="ddlEdiAllergy" onchange="$editAllergylist(this)"></select>
                                    <span id="spnAllergyID" style="display: none"></span>
                                </div>
                            </div>
                            <div class="row" id="divCreatenewallergy" style="display: none">
                                <div class="col-md-10">
                                    <label class="pull-left">AllergyName </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-14">
                                    <input type="text" autocomplete="off" onlytext="30" id="txtAllergy" class="form-control ItDoseTextinputText requiredField"  />
                                </div>
                            </div>


                        </div>
                        <div class="modal-footer">
                            <button type="button" onclick="$saveNewAllergy({AllergyName:$('#txtAllergy').val()})" id="btnSave" value="Save">Save</button>
                            <button type="button" data-dismiss="divNewAllergy">Close</button>
                        </div>
                    </div>
                </div>
            </div>

        </div>

    </form>

    <script type="text/javascript">
        function Search() {
            var Appid = '<%=Request.QueryString["App_ID"].ToString()%>';
            var TID = '<%=Request.QueryString["TID"].ToString()%>';
            serverCall('PatientAllergy.aspx/GetDataDetails', { Appid: Appid, TID: TID }, function (response) {
                  var responseData = JSON.parse(response);
                  if (responseData.status) {
                      bindData(responseData.data);
                  }
                  else {
                      $("#tblOutput tbody").empty();
                      hideShowTable(1);
                  }

              });
          }

        function bindData(data) {
            $("#tblOutput tbody").empty();
            $.each(data, function (i, item) {
               
                var strarray = item.Allergies.split(',');
                for (var i = 0; i < strarray.length; i++) {
                     
                    var row = "";
                    row += "<tr>";
                    row += '<td class="GridViewItemStyle" style="text-align: center"  > <label id="tdSN">' + (i + 1) + '</label></td>';
                    row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdId">' + item.ID + '</label></td>';
                    row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdPatientId">' + item.PatientID + '</label></td>';
                    row += '<td class="GridViewItemStyle"  style="display:none" > <label id="tdTransactionId">' + item.TransactionID + '</label></td>';
                    row += '<td class="GridViewItemStyle"  style="text-align: center"> <label id="tdAllergies">' + strarray[i] + '</label></td>';


                    row += '<td class="GridViewItemStyle" style="text-align: center"  > <img id="btnEdit"  src="../../Images/Delete.gif" style="cursor:pointer" onclick=Delete(this)>  </td>';

                    row += "</tr>";
                    $("#tblOutput tbody").append(row);
                }
               
            });
            hideShowTable(2);
        }

          function hideShowTable(Typ) {
              if (Typ == 1) {
                  $("#tblOutput").hide();
              } else {
                  $("#tblOutput").show();
              }
          }



        function Delete(RowId) {
            modelConfirmation('Delete Confirm ?', 'Do you want to delete allergy from patient', 'Yes', 'No', function (response) {
                if (response) {

                    var Id = $(RowId).closest('tr').find('#tdId').text();
                    var AllergyName = $(RowId).closest('tr').find('#tdAllergies').text();

                    serverCall('PatientAllergy.aspx/DeleteData', { Id: Id, AllergyName: AllergyName }, function (response) {
                        var responseData = JSON.parse(response);
                        if (responseData.status) {
                            modelAlert(responseData.response, function () {
                                Search();
                            });
                        }
                        else {
                            modelAlert(responseData.response, function () {

                              });
                          }

                      });
                  }
              });
          }

    </script>
</body>
</html>
