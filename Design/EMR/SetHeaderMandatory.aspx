<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SetHeaderMandatory.aspx.cs" Inherits="Design_EMR_SetHeaderMandatory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        var IsEdit = false;
        $(document).ready(function () {
          
           // binHeader(function () { });
            bindDepartment();
            bindDischargeType();
        });
        var binHeader = function (callback) {
          
           

            $ddlHeader = $('#ddlheadertype');
            serverCall('Services/EMR.asmx/BindHeader', {}, function (response) {
              
                //var data = JSON.parse(response);
                //$("[id$=ddlheadertype]").append('<option selected = "selected" value = "0" >--Select Header Name--</option >');
                //if (data != null && data.length > 0) {
                //    for (var i = 0; i < data.length; i++) {
                //        $("[id$=ddlheadertype]").append('<option value="' + data[i].Header_Id + '">' + data[i].HeaderName + '</option>');
                //    }
                //}
                $ddlHeader.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'Header_Id', textField: 'HeaderName', isSearchAble: true });
                callback($ddlHeader.find('option:selected').text());
                
            });
        }

        var ValidateAndSave = function () {
          

            var DischargeType = $("[id$=ddlheader]").val();

            var HeaderType = $("[id$=ddlheadertype]").val();
            var DepartmentType = $("[id$=ddlDepartment]").val();
            if (DischargeType == "0") {
                modelAlert('Please Select Dischare Type', function () {
                    $('#ddlheadertype').focus();
                });
                return false;
            }
              if (DepartmentType == "0" || DepartmentType == null) {
                modelAlert('Please Select Department Name', function () {
                    $('#ddlDepartment').focus();
                });
                return false;
            }
            if (HeaderType == "0" || HeaderType == null) {
                modelAlert('Please Select Header Type', function () {
                    $('#ddlheadertype').focus();
                });
                return false;
            }
          

            var data = {
                DischargeType: $("[id$=ddlheader]").find('option:selected').text(),
                HeaderType: $("[id$=ddlheadertype]").find('option:selected').val(),
                DepartmentId: $("[id$=ddlDepartment]").find('option:selected').val(),
                MendtoryType: $("[id$=ddlMendtoryType]").find('option:selected').val(),
            }



            serverCall('Services/EMR.asmx/SaveDischargeType', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    bindDischargeType();

                   

                });
            });
        }


        function Delete(ctrl) {
          
            serverCall('Services/EMR.asmx/deleteDischargeType', { Id: ctrl }, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    bindDischargeType();



                });
            });
        }

       
        function bindDepartment() {
            $ddlDepartment = $('#ddlDepartment');
            serverCall('services/EMR.asmx/BindDepartment', {}, function (response) {
                $ddlDepartment.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ID', textField: 'Department', isSearchAble: true });
               // callback($ddlDepartment.find('option:selected').text());
            });
        }
        function bindDischargeType() {
          
            var DischargeName = $("[id$=ddlheader]").find('option:selected').text();
            if (DischargeName == "All") {
                DischargeName = '';
            }
            serverCall('Services/EMR.asmx/bindDischargeType', { DischargeName: DischargeName }, function (response) {
                var responseData = JSON.parse(response);
                bindDetails(responseData);
                // Clear();
            });
        }
        function bindDetails(data) {
          
            $('#tbDocumentList tbody').empty();
            var row = '';
            for (var i = 0; i < data.length; i++) {
              
                var j = $('#tbDocumentList tbody tr').length + 1;
                row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tddocumentname" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DischargeName + '</td>';
                row += '<td id="tdDepartmenttname" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DepartmentName + '</td>';
                row += '<td id="tddescription" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].HeaderName + '</td>';
                row += '<td id="tddescription" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].mandatoryType + '</td>';


                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CreatedBy + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DateTime + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/Delete.gif" onclick="Delete(' + data[i].Id + ');" style="cursor: pointer;" title="Click To Delete" /></td>';

                row += '<td id="tdAID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ID + '</td>';
                row += '</tr>';

                $('#tbDocumentList tbody').append(row);
            }
        }
        function Clear() {
            binHeader(function () {

            });
            $("[id$=ddlheader]").val(0);
            bindDischargeType();
        }
       
      
        SearchbyfirstName = function (elem) {
          
            debugger;
            var name = $.trim($(elem).find('option:selected').text());
            if (name != "All") {
                var length = $.trim($(elem).find('option:selected').text()).length;

                $('#tbDocumentList tr').hide();
                $('#tbDocumentList tr:first').show();
                $('#tbDocumentList tr').find('td:eq(1)').filter(function () {
                    debugger;
                    if ($(this).text().substring(0, length).toLowerCase() == name.toLowerCase())
                        return $(this);
                }).parent('tr').show();
            }
            else {
                bindDischargeType();
            }
        }

        function bindDischargeHeader(id)
        {
            serverCall('Services/EMR.asmx/BinddischargeHeaderDepartmentwise', { DepartmentID: id }, function (response) {
                var responseData = JSON.parse(response);
                $ddlHeader = $('#ddlheadertype');
                if (responseData!= '0')
                $ddlHeader.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'Header_Id', textField: 'HeaderName', isSearchAble: true });
                else{modelAlert('No Discharge Header bind against Clinic Services');}
            });
        }


    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Set Header Mandatory Or Non-Mandatory</b>
            <span style="display: none" id="spnDocumentID"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Enter Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">


                        <div class="col-md-3">
                            <label class="pull-left">Discharge Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlheader" runat="server" CssClass="required" onchange="SearchbyfirstName(this)">
                                <asp:ListItem Text="All" Value="0"></asp:ListItem>
                                <asp:ListItem Text="DISCHARGE SUMMARY" Value="1"></asp:ListItem>
                                <asp:ListItem Text="TRANSFER SUMMARY" Value="2"></asp:ListItem>
                                <asp:ListItem Text="DEATH SUMMARY" Value="3"></asp:ListItem>
                                <asp:ListItem Text="REFERRAL SUMMARY" Value="4"></asp:ListItem>
                                <%--<asp:ListItem Text="Treatmen Summary" Value="4"></asp:ListItem>--%>
                                <asp:ListItem Text="LAMA SUMMARY" Value="5"></asp:ListItem>
                                <asp:ListItem Text="ABSCONDING SUMMARY" Value="8"></asp:ListItem>
                                <%--<asp:ListItem Text="Discharge On Request Summary" Value="6" ></asp:ListItem>
                                <asp:ListItem Text="Discharge On Persistant Request Summary" Value="7" ></asp:ListItem>--%>
                                <asp:ListItem Text="DEPARTMENT OF PAEDIATRICS & NEONATOLOGY" Value="7"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                         <div class="col-md-3">
                            <label class="pull-left">Deaprtment</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                                <asp:DropDownList ID="ddlDepartment"  runat="server" ClientIDMode="Static" CssClass="required" TabIndex="2" ToolTip="Select Header" onchange="bindDischargeHeader(this.value)"></asp:DropDownList>
                          
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">Header</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                                <asp:DropDownList ID="ddlheadertype"  runat="server" ClientIDMode="Static" CssClass="required" TabIndex="2" ToolTip="Select Header"></asp:DropDownList>
                          <%--  <asp:DropDownList runat="server" ID="ddlheadertype"></asp:DropDownList>--%>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                        <label class="pull-left">MandtoryType</label>
                            <b class="pull-right">:</b>
                        </div>
                       <div class="col-md-5">
                           <asp:DropDownList ID="ddlMendtoryType" runat="server" ClientIDMode="Static">
                               <asp:ListItem Value="0">No</asp:ListItem>
                               <asp:ListItem Value="1">Yes</asp:ListItem>
                               
                           </asp:DropDownList>
                       </div>
                    </div>

                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <input type="button" id="btnSave" value="Save" onclick="ValidateAndSave()" />
                <input type="button" id="btnClear" value="Clear" onclick="Clear()" />

            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Header Mandatory Details
            </div>

            <div class="row">
                <div id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tbDocumentList" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Discharge Name</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Department Name</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Header Name</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Mandtory Type</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Created By</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Created Date Time</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Delete</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

