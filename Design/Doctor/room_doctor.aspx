<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Room_Doctor.aspx.cs" Inherits="Design_OPD_Room_Doctor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            getDepartment();
            //bindData('0');
            $("#btnUpdate").hide();
        });
        function fillGrid(id)
        {
            var deptid = $('#<%=ddlDept.ClientID %>').val();
            bindData(deptid);
        }
        function edit(id)
        {
            //alert('<%=txtRoomNo.ClientID %>');
            var id1 = $(id).closest('tr').find('.ID').text();
            localStorage.setItem('id', id1);
         var roomno=   $(id).closest('tr').find('.RoomNo').text();

         var deptid = $(id).closest('tr').find('.Dept').text();
         var isactivebit = $(id).closest('tr').find('.IsActive').text();
         if (isactivebit == "1") {
             $("#chkIsActive").prop('checked',true);
         }
         else
         {
             $("#chkIsActive").prop('checked',false);
         }

         
         $('#<%=txtRoomNo.ClientID %>').val(roomno);
            $('#<%=ddlDept.ClientID %>').val(deptid).trigger("chosen:updated");

            $("#btnSave").hide();

            $("#btnUpdate").show();
            //alert(id);

        }

        function updateDepartmentRoom() {

            var id = localStorage.getItem('id');
            var roomno = $('#<%=txtRoomNo.ClientID %>').val();
            var deptid = $('#<%=ddlDept.ClientID %>').val();
            if ($('#<%=ddlDept.ClientID %>').val() == "") {
                alert("Select department.");
                return false;
            }
            if ($('#<%=txtRoomNo.ClientID %>').val() == "") {
                alert("Room No required.");
                return false;
            }
            var isactive = '0';
            if ($("#chkIsActive").is(':checked') == true)
                isactive = '1';
            else
                isactive = '0';


            $.ajax({
                type: "POST",
                data: JSON.stringify({ Id: id, RoomNo: roomno, DepartmentId: deptid, IsActive: isactive, CenterID: $('#ddlCentre').val() }),
                url: "Room_Doctor.aspx/updateDepartmentRoom",
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                timeout: 120000,
                async: false,
                success: function (result) {
                    var rs = (result.d);
                    if (rs == "1") {
                        $("#lblMsg").text('Record Updated Successfully');
                        bindData(deptid);
                        $('#<%=txtRoomNo.ClientID %>').val('');
                        $('#<%=ddlDept.ClientID %>').val('0').trigger("chosen:updated");

                        $("#btnSave").show();

                        $("#btnUpdate").hide();
                    }
                    else {
                        if (rs == "2") {
                            $("#lblMsg").text('Room in department already exist.');
                            bindData(deptid);
                        }
                        else {
                            $("#lblMsg").text('Error occurred, Please contact administrator');
                            bindData(deptid);
                        }
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $("#lblMsg").text('Error occurred, Please contact administrator');
                    //$('#btnSave').removeProp('disabled');
                }

            });
        }

        function saveDepartmentRoom() {
            
           
            var roomno = $('#<%=txtRoomNo.ClientID %>').val();
           var deptid = $('#<%=ddlDept.ClientID %>').val();
            if ($('#<%=ddlDept.ClientID %>').val() == "") {
                alert("Select department.");
                return false;
            }
            if ($('#<%=txtRoomNo.ClientID %>').val() == "") {
                alert("Room No required.");
                return false;
            }
            var isactive = '0';
            if ($("#chkIsActive").is(':checked') == true)
                isactive = '1';
            else
                isactive = '0';
            

                $.ajax({
                    type: "POST",
                    data: JSON.stringify({ RoomNo: roomno, DepartmentId: deptid, IsActive: isactive, CenterID: $('#ddlCentre').val() }),
                    url: "Room_Doctor.aspx/saveDepartmentRoom",
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    timeout: 120000,
                    async: false,
                    success: function (result) {
                        var rs = (result.d);
                        if (rs == "1") {
                            $("#lblMsg").text('Record Saved Successfully');
                            bindData(deptid);

                            $('#<%=txtRoomNo.ClientID %>').val('');
                            $('#<%=ddlDept.ClientID %>').val('0').trigger("chosen:updated");

                            $("#btnSave").show();

                            $("#btnUpdate").hide();
                        }
                        else {
                            if (rs == "2") {

                                $("#lblMsg").text('Room in Department already exist.');
                                bindData(deptid);
                            }
                            else {
                                $("#lblMsg").text('Error occurred, Please contact administrator');
                                bindData(deptid);
                            }
                        }
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                        $("#lblMsg").text('Error occurred, Please contact administrator');
                        //$('#btnSave').removeProp('disabled');
                    }

                });
            }
        function bindData(dptid) {
            if (dptid != '') {
                $.ajax({
                    type: "POST",
                    url: "Room_Doctor.aspx/BindDetails",
                    data: JSON.stringify({ deptid: dptid, CenterID: $('#ddlCentre').val() }),
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: true,
                    success: function (response) {
                      
                     IPD = jQuery.parseJSON(response.d);
                       
                            var output = $('#tb_Search').parseTemplate(IPD);
                            $('#IPDOutput').html(output).customFixedHeader();
                        //$('#divAppointmentDetails').customFixedHeader();
                            //$('#IPDOutput').show();

                           },
                    error: function (xhr, status) {
                        $("#btnSearch").val('Search').removeAttr("disabled");
                    }
                });
            }
        }
        function getDepartment() {
            var ddlDepartment = $('#<%=ddlDept.ClientID %>');
            jQuery("#ddlDept option").remove();
            var department = {
                type: "POST",
                url: "../Common/CommonService.asmx/bindDepartment",
                data: '{ }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                    department = jQuery.parseJSON(result.d);
                    if (department != null) {
                        ddlDepartment.chosen('destroy');
                        ddlDepartment.append(jQuery("<option></option>").val("0").html("--Select--"));
                        if (department.length == 0) {
                            ddlDepartment.append(jQuery("<option></option>").val("ALL").html("---No Data Found---"));
                        }
                        else {
                            for (i = 0; i < department.length; i++) {
                                ddlDepartment.append(jQuery("<option></option>").val(department[i].ID).html(department[i].Name));
                            }
                        }
                    }
                    ddlDepartment.chosen();
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                }
            };
            jQuery.ajax(department);
        }

    </script>
  <br />
    <br />
     <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Room Details</b><br />
                <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
           
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">

                 <div class="col-md-3">
                    <label class="pull-left">
                                Centre
                            </label>
                            <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                 <asp:DropDownList ID="ddlCentre" runat="server" ClientIDMode="Static"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Clinic
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlDept" runat="server" CssClass="chosen-container chosen-container-single" onchange="fillGrid(this);" TabIndex="2" AutoPostBack="false" OnSelectedIndexChanged="ddlDept_SelectedIndexChanged"
                        ToolTip="Select Department">
                    </asp:DropDownList>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">
                        Room No
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtRoomNo" runat="server" AutoCompleteType="Disabled"
                        ToolTip="Enter Room No" TabIndex="1"></asp:TextBox>
                </div>
                <div class="col-md-2">
                      <input type="checkbox" id="chkIsActive" value="IsActive" />IsActive
                </div>
              

            </div>
             
            <div class="row" style="text-align:center">
                 
                <div class="col-md-24" style="text-align:center">

                    <input type="button" id="btnSave" value="Save" class="ItDoseButton" onclick="saveDepartmentRoom();" />
                    &nbsp;&nbsp;
                            <input type="button" id="btnUpdate" value="Update" class="ItDoseButton" onclick="updateDepartmentRoom();" />
                    &nbsp;&nbsp;
           
                      </div>
                        
</div>
            </div>
    <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Room Details
                </div>
        
				<div id="IPDOutput" style="height:280px;width:100%;overflow-y:auto"> </div>
            <script id="tb_Search" type="text/html">
		<table class="FixedTables"  id="tb_grdIPD"  cellspacing="0" rules="all" border="1"  style="width:100%;border-collapse:collapse;">
			<thead>
			<tr id="Header">
				<th class="GridViewHeaderStyle" scope="col">Room No</th>
				<th class="GridViewHeaderStyle" scope="col">Department</th>
				
                <th class="GridViewHeaderStyle" scope="col">IsActive</th>
                <th class="GridViewHeaderStyle" scope="col">Edit</th>
				</tr>
				</thead>
			<#       
				var dataLength=IPD.length;
				window.status="Total Records Found :"+ dataLength;
				var objRow;   
				var status;
				for(var j=0;j<dataLength;j++)
				{       
					objRow = IPD[j];
			#>
			<tbody>
			<tr id="<#=j+1#>" 
			 > 
				
				<td class="GridViewLabItemStyle" id="tdRoom"  ><span id="spanId" class="ID" style="display:none;" ><#=objRow.ID#></span><span id="spanRoomNo"  class="RoomNo" ><#=objRow.RoomNo#></span></td>
                <td class="GridViewLabItemStyle" id="tdDepartment"  ><span id="spanDepartmentId" class="Dept" style="display:none;" ><#=objRow.DepartmentId#></span><#=objRow.DepartmentName#></td>
			
                <td class="GridViewLabItemStyle" id="td1"   ><#=objRow.IsActive1 #><span class="IsActive" style="display:none;"><#=objRow.IsActive #></span></td>
                	<td class="GridViewLabItemStyle" id="tdPatientID"   ><a href="#" onclick="edit(this);">Edit</a></td>
				</tr>     
			</tbody>      
			<#}#>       
		</table>    
	</script>
    <asp:GridView ID="GridView1" runat="server" Width="100%" AutoGenerateColumns="False" 
                            TabIndex="5" CssClass="GridViewStyle"
                    >
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="RoomNo" HeaderText="RoomNo">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="250px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="280px" />
                        </asp:BoundField>
                        
                        <asp:BoundField DataField="DepartmentName" HeaderText="Department Name">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="250px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="280px" />
                        </asp:BoundField>
                        
                        
                    </Columns>
                </asp:GridView>
        </div>

</asp:Content>

