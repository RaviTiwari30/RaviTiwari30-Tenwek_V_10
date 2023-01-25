<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PanelGroupMaster.aspx.cs" Inherits="Design_EDP_PanelGroupMaster" MasterPageFile="~/DefaultHome.master" %>

<asp:Content ID="c1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <script type="text/javascript">
            $(document).ready(function () {

                BindPanelGroup(function () {

                });
            });

            var BindPanelGroup = function (callback) {
                serverCall('PanelGroupMaster.aspx/BindPanelGroup', {}, function (response) {
                    var responseData = JSON.parse(response);
                    bindPanelDetail(responseData.response);
                });
                callback();
            }

            var bindPanelDetail = function (data) {
                $('#tblPanelGroup tbody').empty();
                for (var i = 0; i < data.length > 0; i++) {

                    var j = $('#tblPanelGroup tbody tr').length + 1;
                    var row = '<tr>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdPanelGroupName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].PanelGroup + '</td>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/edit.png" onclick="EditPanelGroup(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                    row += '<td id="tdPanelGroupID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].PanelGroupID + '</td>';
                    row += '</tr>';

                    $('#tblPanelGroup tbody').append(row);
                }
            }

            var EditPanelGroup = function (rowID) {
                var row = $(rowID).closest('tr');
                $('#txtPanelGroup').val($(row).find('#tdPanelGroupName').text().trim());
                
                $('#spnPanelGroupID').text($(row).find('#tdPanelGroupID').text().trim());
                $('#btnSave').val('Update');
            }

            var Save = function () {
                data = {
                    GroupName: $('#txtPanelGroup').val().trim(),
                    GroupID: $('#spnPanelGroupID').text().trim(),
                }

                if (String.isNullOrEmpty(data.GroupName)) {
                    modelAlert('Please Enter Group Name', function () {
                        $('#txtPanelGroup').focus();
                    });
                    return false;
                }
                serverCall('PanelGroupMaster.aspx/SavePanelGroup', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        modelAlert(responseData.response, function () {
                            BindPanelGroup(function () {
                                ClearControls();
                                $('#btnSave').val('Save');
                            });
                        });
                    }
                    else {
                        modelAlert(responseData.response, function () { });
                    }
                });
            }
            var ClearControls = function () {
                $('#txtPanelGroup').val('');
            
                $('#spnPanelGroupID').text('');
            }
            </script>
    <div id="Pbody_box_inventory">
               <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Panel Group Master</b>
            <span id="spnPanelGroupID" class="hidden"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                     <div class="row">
                        
                        <div class="col-md-3">
                            <label class="pull-left">Group Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <input type="text" id="txtPanelGroup" maxlength="200" class="requiredField" />
                        </div>
                         </div>
                    </div>
                <div class="col-md-1"></div>
                </div>
          
            <div class="row" style="text-align:center">
                <input type="button" id="btnSave" value="Save" onclick="Save()" />
                
            </div>
    
    </div>
               <div class="POuter_Box_Inventory">
            <div class="row">
                <div style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" cellspacing="0" id="tblPanelGroup"rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" style="width: 120px;">Panel Group</th>
                                <th class="GridViewHeaderStyle" style="width: 30px;">Edit</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
        </div>
    </asp:Content>

