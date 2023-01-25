<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MapDepartmentWithRole.aspx.cs" Inherits="Design_EDP_MapDepartmentWithRole" %>

<%-- Add content controls here --%>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Department Map With Role</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Department 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlDepartment" onchange="DepartmentChange()"  class="required"></select>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Role 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlRole" onchange="DepartmentChange()"  class="required"></select>
                </div>
                <div class="col-md-8" style="text-align: right">
                    <input type="button" value="MAP" id="btnSave" onclick="Save()" />
                </div>
            </div>
             
        </div>


        <div class="POuter_Box_Inventory">
            <div id="divOutput" style="overflow-y: auto; overflow-x: auto;">

                <table id="tbldepartmentMap" rules="all" border="1" style="border-collapse: collapse; width: 100%; display: none" class="GridViewStyle">
                    <thead> 
                        <tr>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align: center">SN.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Department Name</th>
                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Role</th>
                            <th class="GridViewHeaderStyle" scope="col" style="display: none; text-align: center">RoleID</th>
                            <th class="GridViewHeaderStyle" scope="col" style="display: none; text-align: center">DepartmentID</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align: center">Action</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>


        </div>



    </div>

    <script type="text/javascript">


        $(document).ready(function () {
            bindDepartment();
            ddlGetRole();
            SearchData("0",0);
        });
         

        function bindDepartment () {
            var $ddlDepartment = $('#ddlDepartment');
            serverCall('../common/CommonService.asmx/bindDepartment', {}, function (response) {
                $ddlDepartment.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: true });
            
            });
        }

        function ddlGetRole() {
            var ddlRole = $('#ddlRole');
            serverCall('MapDepartmentWithRole.aspx/GetRole', {}, function (response) {
                ($(ddlRole).bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'ID', textField: 'RoleName', isSearchable: true }));
            });
        }

 
        function Save() {

            var data = new Object();
            data.DeptId = $("#ddlDepartment").val();
            data.DeptName = $("#ddlDepartment option:selected").text(); 
            data.RoleID = $("#ddlRole").val();
            data.RoleName = $("#ddlRole option:selected").text();
 
            if (data.DeptId == "" || data.DeptId == "0" || data.DeptId == undefined || data.DeptId == null) {

                modelAlert("Select Department.")

                return false;
            }
            

            if (data.RoleID == "" || data.RoleID == "0" || data.RoleID == undefined || data.RoleID == null) {

                modelAlert("Select Role.")

                return false;
            }

            $('#btnSave').attr('disabled', true).val("Submitting...");


            serverCall('MapDepartmentWithRole.aspx/MapRoleToDept', { Data: data }, function (response) {

                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {

                    if (responseData.status) {

                        SearchData($("#ddlDepartment").val(), 0);
                        $(btnSave).removeAttr('disabled').val('MAP');
                    }
                    else
                        $(btnSave).removeAttr('disabled').val('MAP');

                });


            });

            

        }

       
        function DepartmentChange() {
            if ($("#ddlDepartment").val() == "" || $("#ddlDepartment").val() == "0") {
                SearchData($("#ddlRole").val(), 1)
            } else {
                SearchData($("#ddlDepartment").val(), 0)

            }
        }

        function SearchData(id,Typ) {


            serverCall('MapDepartmentWithRole.aspx/GetDataToFill', { Id: id,Type:Typ }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {

                    data = GetData.data;
                    var count = 0;
                    $('#tbldepartmentMap tbody').empty();
                    $.each(data, function (i, item) {
                        
                        var rdb = '';
                        rdb += '<tr>';
                        rdb += '<td class="GridViewItemStyle">' + ++count + '</td>';
                        rdb += '<td class="GridViewItemStyle">' + item.DocDepartmentName + '</td>';
                        rdb += '<td class="GridViewItemStyle">' + item.RoleName + '</td>'; 
                        rdb += '<td class="GridViewItemStyle"  style="display:none"> <lable id="lblId">' + item.Id + '</lable> </td>';                      
                        rdb += '<td class="GridViewItemStyle"  style="display:none"> <lable id="lblDocDepartment">' + item.DocDepartment + '</lable> </td>';
                        rdb += '<td class="GridViewItemStyle"  style="display:none"> <lable id="lblRoleId">' + item.RoleId + '</lable> </td>';
                       
                        rdb += '<td class="GridViewItemStyle"><input type="button" value="Un-Mapped" id="btnRemove" style="background-color:Red" onclick="Remove(' + item.Id + ')" /></td>';

                        rdb += '</tr> ';

                        $('#tbldepartmentMap tbody').append(rdb);

                    });

                    $('#tbldepartmentMap').show();
                }
                else {
                    $('#tbldepartmentMap tbody').empty();
                    $('#tbldepartmentMap').hide();
                }
            });
        }

        function Remove(Id) {
            modelConfirmation('Confirmation!!!', 'Are You Sure You Want To Un Mapped Role From Department', 'Continue', 'Close', function (response) {
                if (response) {
                    serverCall('MapDepartmentWithRole.aspx/Unmapped', { Id: Id }, function (response) {
                        var responseData = JSON.parse(response);
                        if (responseData.status) {
                            modelAlert(responseData.response, function () {
                                SearchData($("#ddlDepartment").val(), 0);
                            });
                        }
                        else {

                            modelAlert(responseData.response);
                        }
                    });
                }
            });
        }

    </script>
</asp:Content>
